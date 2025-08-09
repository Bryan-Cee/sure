# Using Local LLM with Sure

This guide explains how to use a local LLM (like Ollama) instead of OpenAI with the Sure personal finance app.

## Overview

Sure now supports both OpenAI and local LLMs through Ollama. The system will automatically prefer Ollama if it's available and running.

## Setting up Ollama

1. **Install Ollama**

   ```bash
   # On macOS
   brew install ollama

   # On Linux
   curl -fsSL https://ollama.ai/install.sh | sh
   ```

2. **Start Ollama**

   ```bash
   ollama serve
   ```

3. **Download a model**

   ```bash
   # Download Llama 3.2 (recommended)
   ollama pull llama3.2

   # Or try other models
   ollama pull llama3.1
   ollama pull mistral
   ollama pull codellama
   ```

## Configuration

### Environment Variables

Set these environment variables in your `.env` file or system environment:

```bash
# Ollama configuration (optional - defaults shown)
OLLAMA_BASE_URL=http://localhost:11434

# You can still keep OpenAI as fallback
OPENAI_ACCESS_TOKEN=your_openai_token_here
```

### Docker Compose

If you're using Docker, add the Ollama configuration to your `compose.yml`:

```yaml
services:
  app:
    environment:
      # Ollama configuration
      OLLAMA_BASE_URL: http://host.docker.internal:11434

      # Keep OpenAI as fallback (optional)
      OPENAI_ACCESS_TOKEN: ${OPENAI_ACCESS_TOKEN}
```

Note: If running Ollama on the host machine and Sure in Docker, use `host.docker.internal:11434` to access the host's Ollama instance.

## How it Works

### Provider Priority

The system checks providers in this order for LLM tasks:

1. **Ollama** - If accessible at the configured URL
2. **OpenAI** - If API token is configured

### Supported Models

The Ollama provider supports these models:

- `llama3.2` (recommended)
- `llama3.1`
- `mistral`
- `codellama`
- `qwen2.5`
- `llama2`

### Features

- ✅ **Chat Assistant** - Interactive financial conversations
- ✅ **Auto-categorization** - Automatic transaction categorization
- ✅ **Merchant Detection** - Smart merchant name detection
- ✅ **Streaming responses** - Real-time chat responses
- ❌ **Function calling** - Not yet implemented for Ollama

## Benefits of Local LLM

- **Privacy** - Your data never leaves your system
- **Cost** - No API costs after initial setup
- **Speed** - Often faster responses (depending on hardware)
- **Control** - Full control over model selection and updates
- **Offline** - Works without internet connection

## Performance Considerations

### Hardware Requirements

- **Minimum**: 8GB RAM for smaller models (7B parameters)
- **Recommended**: 16GB+ RAM for larger models (13B+ parameters)
- **Optimal**: 32GB+ RAM with dedicated GPU

### Model Selection

- **llama3.2** - Latest with improved capabilities (recommended)
- **llama3.1** - Excellent balance of capability and performance
- **mistral** - Fast and efficient for most tasks
- **codellama** - Better for code-related financial queries

## Troubleshooting

### Ollama Not Accessible

If the system falls back to OpenAI, check:

1. Ollama is running: `ollama list`
2. Accessible at correct URL: `curl http://localhost:11434/api/version`
3. Model is downloaded: `ollama pull llama3.2`

### Slow Responses

- Use smaller models (7B parameter models)
- Ensure adequate RAM
- Consider GPU acceleration if available

### Docker Issues

If using Docker and can't access Ollama:

```bash
# Test connection from within container
docker exec -it sure_app_1 curl http://host.docker.internal:11434/api/version
```

## Fallback to OpenAI

The system gracefully falls back to OpenAI if:

- Ollama is not accessible
- Ollama model fails to respond
- Specific OpenAI features are needed

This ensures the app continues working even if your local LLM is unavailable.
