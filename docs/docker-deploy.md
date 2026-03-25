# 🐳 Docker Deployment Standards

> **Rule:** Never `docker build` + `docker run` manually. Always use `docker compose` or deployment scripts.

AI agents love running one-off Docker commands. The result? Orphaned containers, port conflicts, missing volumes, and "it worked on my machine" debugging sessions. This guide standardizes deployment.

---

## The Rules

### 1. Always Use Docker Compose

```bash
# ❌ NEVER
docker build -t myapp .
docker run -d -p 3000:3000 myapp

# ✅ ALWAYS
docker compose up -d --build

# Or use a deploy script
bash deploy.sh
```

### 2. Verify After Deploy

```bash
# Check containers are running
docker compose ps

# Verify port bindings
docker port <container-name> <port>

# Check logs for errors
docker compose logs --tail=50

# Health check
curl -f http://localhost:3000/health || echo "UNHEALTHY"
```

### 3. Standard docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: myapp-web
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - ./config:/app/config:ro    # Config as read-only mount
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    container_name: myapp-api
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=mongodb://db:27017/myapp
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: mongo:7
    container_name: myapp-db
    volumes:
      - db-data:/data/db
    restart: unless-stopped

volumes:
  db-data:
```

### 4. Deploy Script Template

```bash
#!/bin/bash
# deploy.sh — Standard deployment script

set -euo pipefail

echo "🚀 Deploying..."

# Pull latest code
git pull origin main

# Build and restart
docker compose down
docker compose up -d --build

# Wait for health
echo "⏳ Waiting for health check..."
sleep 10

# Verify
docker compose ps
docker port myapp-web 3000 && echo "✅ Web OK" || echo "❌ Web FAILED"
docker port myapp-api 3001 && echo "✅ API OK" || echo "❌ API FAILED"

# Health check
curl -sf http://localhost:3000/health > /dev/null && echo "✅ Health OK" || echo "❌ Health FAILED"

echo "🎉 Deploy complete"
```

---

## Agent Instructions

When agents need to deploy:

```markdown
## Deploy Rules
1. ALWAYS use `docker compose up -d --build` or `bash deploy.sh`
2. NEVER use `docker build` + `docker run` separately
3. After deploy, verify:
   - `docker compose ps` — all containers running
   - `docker port <name> <port>` — ports bound correctly
   - `curl health endpoint` — service responding
4. If deploy fails, check logs: `docker compose logs --tail=100`
```

---

*Standardized across 5+ Docker deployments, zero orphaned container incidents.*
