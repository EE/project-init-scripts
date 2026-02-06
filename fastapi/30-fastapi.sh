#!/bin/bash

# Install FastAPI and Uvicorn
poetry add 'fastapi==*'
poetry add 'uvicorn[standard]==*'
poetry add --group dev 'httpx==*'

# Check if the FASTAPI_PROJECT_NAME environment variable is set
if [[ -z "$FASTAPI_PROJECT_NAME" ]]; then
    echo "FASTAPI_PROJECT_NAME environment variable is not set. Using the current directory name as the project name."
    FASTAPI_PROJECT_NAME=$(basename "$PWD")
    # Replace forbidden characters in project name
    FASTAPI_PROJECT_NAME=${FASTAPI_PROJECT_NAME//[-.]/_}
    export FASTAPI_PROJECT_NAME
fi

# Create the main application directory
mkdir -p "$FASTAPI_PROJECT_NAME"

# Create config module
cat > "$FASTAPI_PROJECT_NAME/config.py" <<EOF
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    debug: bool = False
    database_url: str = "postgresql+asyncpg://localhost/app"
    secret_key: str = "changeme"


settings = Settings()
EOF

# Create the main application file
cat > "$FASTAPI_PROJECT_NAME/main.py" <<EOF
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello, World!"}


@app.get("/health")
async def health():
    return {"status": "healthy"}
EOF

# Create __init__.py
cat > "$FASTAPI_PROJECT_NAME/__init__.py" <<EOF
EOF

# Create test file
cat > "test_app.py" <<EOF
from fastapi.testclient import TestClient

from $FASTAPI_PROJECT_NAME.main import app

client = TestClient(app)


def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello, World!"}


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
EOF

# Add to README
cat <<EOF >> "README.md"

## Running the Application

Start the development server:

    poetry run uvicorn $FASTAPI_PROJECT_NAME.main:app --reload

The API will be available at http://localhost:8000
EOF

poetry run isort .
git add --all
git commit -m "Initialize FastAPI application"
