## Parent image
FROM python:3.12-slim

## Essential environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

## Work directory inside the docker container
WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

## Copying all contents from local(github) to app
COPY . .

# Used PORTS
EXPOSE 8501

# Run the app
ENV PATH="/app/.venv/bin:$PATH"
CMD ["streamlit", "run", "app/chatbot.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true"]