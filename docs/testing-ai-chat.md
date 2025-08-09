# Testing AI Chat with Local LLM

Your Sure application is now configured with Ollama (llama3.2) for privacy-focused AI features. Here's how to test and use the AI chat functionality.

## ✅ Pre-flight Check

Run the AI test script to verify everything is working:

```bash
./bin/ai-test
```

This should show:

- ✅ Ollama is running locally
- ✅ Web container can access Ollama
- ✅ llama3.2 model is available
- ✅ Sure web application is running

## 🌐 Accessing the AI Chat

### Step 1: Open the Application

Navigate to: **http://localhost:3000**

### Step 2: Create Account or Log In

If this is your first time:

1. Click "Create your account"
2. Enter your email and password
3. Complete the registration

If you already have an account:

1. Enter your credentials on the login page

### Step 3: Find the Chat Feature

Once logged in, look for:

- **"Chat"** link in the main navigation
- **"AI Assistant"** or **"Ask Maybe AI"** button
- **Chat icon** in the sidebar or header

_Note: The exact location may vary depending on the UI layout_

## 💬 Testing AI Conversations

### Financial Questions to Try

Start with these example prompts to test the AI:

**Budgeting & Planning:**

- "How can I create a monthly budget?"
- "What's the 50/30/20 rule for budgeting?"
- "Help me plan for an emergency fund"

**Expense Tracking:**

- "What's the best way to track my daily expenses?"
- "How should I categorize my spending?"
- "Help me understand my spending patterns"

**Investment & Savings:**

- "What are some basic investment principles?"
- "How much should I save each month?"
- "Explain the difference between stocks and bonds"

**Transaction Help:**

- "Help me categorize this transaction: $50 at Target"
- "How should I handle recurring subscriptions in my budget?"

### Expected Behavior

With the local LLM (llama3.2), you should see:

- **Streaming responses** - text appears word by word in real-time
- **Financial expertise** - relevant, helpful financial advice
- **Privacy** - all processing happens locally, no data sent to external APIs
- **No API costs** - completely free to use

## 🔧 Troubleshooting

### AI Chat Not Available

If you don't see chat options:

1. **Check user permissions:**

   ```bash
   docker compose exec web bundle exec rails runner "puts User.first&.ai_enabled?"
   ```

2. **Verify provider is working:**
   ```bash
   docker compose exec web bundle exec rails runner "
   registry = Provider::Registry.for_concept(:llm)
   provider = registry.providers.first
   puts provider ? 'Provider loaded: ' + provider.class.name : 'No provider found'
   "
   ```

### Chat Feature Exists But Doesn't Respond

1. **Check Ollama connectivity:**

   ```bash
   docker compose exec web curl -s http://host.docker.internal:11434/api/version
   ```

2. **Check application logs:**

   ```bash
   docker compose logs web -f
   ```

3. **Test Ollama directly:**
   ```bash
   ollama run llama3.2 "What is personal finance?"
   ```

### Slow Responses

If responses are slow:

- **Model size**: llama3.2 is optimized for speed vs. capability
- **Hardware**: Ensure adequate RAM (8GB+ recommended)
- **Alternative models**: Try `ollama pull llama3.2:1b` for faster responses

### Error Messages

**"AI features not available":**

- Verify Ollama is running: `ollama serve`
- Check the model is downloaded: `ollama list`

**"Provider connection failed":**

- Test connectivity: `./bin/ai-test`
- Check environment variables in `.env`

## 🎯 Advanced Testing

### Test Auto-Categorization

1. Add some transactions to your account
2. Look for "Auto-categorize" or "AI Categorize" buttons
3. The system should suggest categories using the local LLM

### Test Merchant Detection

1. Import or add transactions with unclear merchant names
2. The AI should clean up and standardize merchant names

### Monitor Performance

```bash
# Watch resource usage
docker stats

# Monitor Ollama
ollama ps

# Check response times in logs
docker compose logs web | grep -i "completed.*ms"
```

## 🔒 Privacy Benefits

Using the local LLM means:

- **No external API calls** - your financial data never leaves your system
- **No usage tracking** - no third parties monitoring your questions
- **No rate limits** - unlimited conversations
- **No costs** - completely free after initial setup
- **Offline capable** - works without internet connection

## 🎉 Success Indicators

You'll know it's working when:

- Chat interface loads and accepts input
- Responses stream in real-time (word by word)
- Financial advice is relevant and helpful
- No error messages in browser console
- Docker logs show successful LLM connections

Your local AI financial assistant is ready to help with budgeting, expense tracking, and financial planning - all with complete privacy!
