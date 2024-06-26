# Install WhiteNoise
poetry add 'whitenoise==*'

# Update the settings.py file to use WhiteNoise middleware
sed -i "/django.middleware.security.SecurityMiddleware/a \    'whitenoise.middleware.WhiteNoiseMiddleware'," "$DJANGO_PROJECT_NAME/settings.py"

# Configure Django to use WhiteNoise for serving static files
cat >> "$DJANGO_PROJECT_NAME/settings.py" <<EOL

# WhiteNoise settings
STATIC_ROOT = BASE_DIR / "staticfiles"
STORAGES = {
    "staticfiles": {
        "BACKEND": "whitenoise.storage.CompressedManifestStaticFilesStorage",
    },
}
EOL

# gitignore the staticfiles directory
echo "staticfiles/" >> .gitignore

# Commit the changes
git add --all
git commit -m "Configure WhiteNoise for serving static files"
