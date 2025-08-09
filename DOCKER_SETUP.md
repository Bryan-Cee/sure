# Local Docker Setup with Ollama Support

This directory contains the necessary files to run Sure locally with Docker, including support for local LLM via Ollama.

## Quick Start

1. **Run the setup script**:

   ```bash
   ./bin/docker-setup
   ```

   This script will:

   - Check Docker installation
   - Create `.env` file from template
   - Check Ollama status
   - Build and start the application
   - Verify everything is working

2. **Access the app**: http://localhost:3000

3. **Create your account** on the login page

## Manual Setup

If you prefer to set up manually:

1. **Copy environment file**:

   ```bash
   cp .env.docker.example .env
   ```

2. **Start Ollama** (for local AI features):

   ```bash
   ollama serve
   ollama pull llama3.1
   ```

3. **Build and start**:
   ```bash
   docker compose up -d --build
   ```

## Configuration

### Environment Variables (.env file)

- `OLLAMA_BASE_URL`: URL to your Ollama instance (default: `http://host.docker.internal:11434`)
- `OPENAI_ACCESS_TOKEN`: Optional OpenAI API key as fallback
- `POSTGRES_*`: Database credentials
- `SECRET_KEY_BASE`: App secret key (generate new for production)

### Ollama Setup

For local LLM support:

1. **Install Ollama**: https://ollama.ai/
2. **Start service**: `ollama serve`
3. **Download model**: `ollama pull llama3.2`

The app will automatically detect and use Ollama if available.

## Features Available

With this setup you get:

- ✅ **Complete Sure application** with all financial features
- ✅ **Local AI chat** via Ollama (privacy-focused)
- ✅ **Auto-categorization** of transactions
- ✅ **Merchant detection** from transaction descriptions
- ✅ **Streaming responses** in real-time
- ✅ **No API costs** for AI features (after Ollama setup)

## Useful Commands

```bash
# View logs
docker compose logs -f

# Stop application
docker compose down

# Restart services
docker compose restart

# Update with code changes
docker compose up -d --build

# Check service status
docker compose ps

# Access database
docker compose exec db psql -U maybe_user -d maybe_production

# Run Rails console
docker compose exec web bundle exec rails console
```

## Troubleshooting

### Ollama Connection Issues

```bash
# Test Ollama from host
curl http://localhost:11434/api/version

# Test from within container
docker compose exec web curl http://host.docker.internal:11434/api/version
```

### Database Issues

```bash
# Reset database (WARNING: deletes all data)
docker compose down
docker volume rm sure_postgres-data
docker compose up -d
```

### Build Issues

```bash
# Force clean rebuild
docker compose down
docker compose build --no-cache
docker compose up -d
```

## File Structure

- `compose.yml` - Docker Compose configuration (builds from local source)
- `.env.docker.example` - Environment variables template
- `bin/docker-setup` - Automated setup script
- `docs/local-llm.md` - Detailed Ollama integration guide

## Next Steps

1. **Explore the app** - Add accounts, transactions, try the AI chat
2. **Customize** - Modify `.env` for your needs
3. **Develop** - Make code changes and rebuild with `docker compose up -d --build`
4. **Deploy** - See `docs/hosting/` for production deployment guides
