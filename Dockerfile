## Parent image
FROM python:3.12-slim

## Essential environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

## Work directory inside the docker container
WORKDIR /app


# ====================================================
## Dependency Handling

# 0. Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# 1. Copy ONLY the lock and toml files
COPY pyproject.toml uv.lock ./

# 2. Install external dependencies ONLY (skips building anime-recommender)
RUN uv sync --frozen --no-dev --no-install-project

# 3. Now copy the rest of your application code
COPY . .

# 4. Run sync one more time to install the local project itself
RUN uv sync --frozen --no-dev
# ========================================================

# Used PORTS
EXPOSE 8501

# Run the app
ENV PATH="/app/.venv/bin:$PATH"
CMD ["streamlit", "run", "app/chatbot.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true"]