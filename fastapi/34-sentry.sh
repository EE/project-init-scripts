#!/bin/bash

# Install Sentry SDK for FastAPI
poetry add 'sentry-sdk[fastapi]==*'

# Update config to include SENTRY_DSN
sed -i '/secret_key: str = "changeme"/a\    sentry_dsn: str = ""' "$FASTAPI_PROJECT_NAME/config.py"

# Add Sentry initialization to main.py
sed -i '1i import sentry_sdk' "$FASTAPI_PROJECT_NAME/main.py"
sed -i '/from fastapi import FastAPI/a\from .config import settings' "$FASTAPI_PROJECT_NAME/main.py"

# Add Sentry initialization after imports
sed -i '/^from .config import settings/a\
\
if settings.sentry_dsn:\
    sentry_sdk.init(\
        dsn=settings.sentry_dsn,\
        traces_sample_rate=0.01,\
    )' "$FASTAPI_PROJECT_NAME/main.py"

# Add SENTRY_DSN to example.env
echo "SENTRY_DSN=" >> example.env

poetry run isort .
git add --all
git commit -m "Install and configure Sentry for FastAPI"
