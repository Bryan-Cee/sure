class Provider::Ollama < Provider
  include LlmConcept

  Error = Class.new(Provider::Error)

  MODELS = %w[llama3.2 llama3.1 mistral codellama qwen2.5 llama2]

  def initialize(base_url = "http://localhost:11434")
    @base_url = base_url.chomp('/')
    require 'net/http'
    require 'json'
    require 'uri'
  end

  def supports_model?(model)
    MODELS.include?(model)
  end

  def chat_response(prompt, model:, instructions: nil, functions: [], function_results: [], streamer: nil, previous_response_id: nil)
    with_provider_response do
      messages = build_messages(prompt, instructions, function_results)

      if streamer.present?
        stream_chat_response(messages, model, streamer)
      else
        sync_chat_response(messages, model)
      end
    end
  end

  def auto_categorize(transactions: [], user_categories: [])
    with_provider_response do
      raise Error, "Too many transactions to auto-categorize. Max is 25 per request." if transactions.size > 25

      # Build a prompt for categorization
      prompt = build_categorization_prompt(transactions, user_categories)

      response = sync_chat_response(
        [{ role: "user", content: prompt }],
        "llama3.2"  # Use a default model for this task
      )

      parse_categorization_response(response, transactions)
    end
  end

  def auto_detect_merchants(transactions: [], user_merchants: [])
    with_provider_response do
      raise Error, "Too many transactions to auto-detect merchants. Max is 25 per request." if transactions.size > 25

      prompt = build_merchant_detection_prompt(transactions, user_merchants)

      response = sync_chat_response(
        [{ role: "user", content: prompt }],
        "llama3.2"
      )

      parse_merchant_response(response, transactions)
    end
  end

  private

  attr_reader :base_url

  def build_messages(prompt, instructions, function_results)
    messages = []

    if instructions.present?
      messages << { role: "system", content: instructions }
    end

    messages << { role: "user", content: prompt }

    function_results.each do |result|
      messages << { role: "assistant", content: result.to_s }
    end

    messages
  end

  def stream_chat_response(messages, model, streamer)
    payload = {
      model: model,
      messages: messages,
      stream: true
    }

    response_id = SecureRandom.uuid

    begin
      uri = URI("#{base_url}/api/chat")
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = payload.to_json

      response = http.request(request) do |resp|
        resp.read_body do |chunk|
          chunk.split("\n").each do |line|
            next if line.strip.empty?

            begin
              data = JSON.parse(line)

              if data['message'] && data['message']['content']
                # Convert Ollama format to expected format
                formatted_chunk = OpenStruct.new(
                  type: "output_text",
                  data: data['message']['content']
                )
                streamer.call(formatted_chunk)
              end

              if data['done']
                # Signal completion
                formatted_response = OpenStruct.new(
                  type: "response",
                  data: OpenStruct.new(
                    id: response_id,
                    function_requests: []
                  )
                )
                streamer.call(formatted_response)
              end
            rescue JSON::ParserError
              # Skip malformed JSON
            end
          end
        end
      end

      OpenStruct.new(
        success?: true,
        data: OpenStruct.new(id: response_id)
      )
    rescue => e
      raise Error, "Failed to connect to Ollama: #{e.message}"
    end
  end

  def sync_chat_response(messages, model)
    payload = {
      model: model,
      messages: messages,
      stream: false
    }

    response_id = SecureRandom.uuid

    begin
      uri = URI("#{base_url}/api/chat")
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = payload.to_json

      response = http.request(request)

      if response.code == '200'
        data = JSON.parse(response.body)

        OpenStruct.new(
          success?: true,
          data: OpenStruct.new(
            id: response_id,
            content: data.dig('message', 'content') || ""
          )
        )
      else
        raise Error, "Ollama API error: #{response.code} #{response.body}"
      end
    rescue => e
      raise Error, "Failed to connect to Ollama: #{e.message}"
    end
  end

  def build_categorization_prompt(transactions, user_categories)
    categories_list = user_categories.map(&:name).join(", ")

    transactions_text = transactions.map.with_index do |txn, idx|
      "#{idx + 1}. Amount: #{txn.amount}, Description: #{txn.description || txn.name}"
    end.join("\n")

    <<~PROMPT
      You are a financial assistant helping categorize transactions.

      Available categories: #{categories_list}

      Transactions to categorize:
      #{transactions_text}

      For each transaction, respond with only the transaction number and the most appropriate category from the list above.
      Format: "1: Category Name"

      If no category fits well, use "Uncategorized".
    PROMPT
  end

  def build_merchant_detection_prompt(transactions, user_merchants)
    merchants_list = user_merchants.map(&:name).join(", ")

    transactions_text = transactions.map.with_index do |txn, idx|
      "#{idx + 1}. Description: #{txn.description || txn.name}"
    end.join("\n")

    <<~PROMPT
      You are a financial assistant helping identify merchants from transaction descriptions.

      Known merchants: #{merchants_list}

      Transactions to analyze:
      #{transactions_text}

      For each transaction, identify the merchant name. If it matches a known merchant, use that exact name.
      If it's a new merchant, suggest a clean merchant name.

      Format: "1: Merchant Name"
    PROMPT
  end

  def parse_categorization_response(response, transactions)
    # Parse the LLM response and return categorizations
    # This would need to match the expected return format from the OpenAI version
    content = response.data.content

    results = []
    transactions.each_with_index do |txn, idx|
      # Simple parsing - in practice you'd want more robust parsing
      category_match = content.match(/#{idx + 1}:\s*([^\n]+)/)
      category = category_match ? category_match[1].strip : "Uncategorized"

      results << {
        transaction: txn,
        category: category
      }
    end

    results
  end

  def parse_merchant_response(response, transactions)
    # Parse the LLM response and return merchant detections
    content = response.data.content

    results = []
    transactions.each_with_index do |txn, idx|
      merchant_match = content.match(/#{idx + 1}:\s*([^\n]+)/)
      merchant = merchant_match ? merchant_match[1].strip : txn.name

      results << {
        transaction: txn,
        merchant: merchant
      }
    end

    results
  end
end
