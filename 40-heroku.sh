# Install Gunicorn
poetry add 'gunicorn==*'

# Create a Procfile for Heroku
cat > Procfile <<EOL
release: python manage.py migrate --no-input
web: gunicorn $DJANGO_PROJECT_NAME.wsgi
EOL

# Create an app.json file for Heroku
cat > app.json <<EOL
{
  "addons": [
    "heroku-postgresql:essential-0"
  ],
  "buildpacks": [
    {
      "url": "https://github.com/moneymeets/python-poetry-buildpack.git"
    },
    {
      "url": "heroku/python"
    }
  ],
  "env": {
    "DJANGO_SETTINGS_MODULE": "$DJANGO_PROJECT_NAME.settings",
    "SECRET_KEY": {
      "description": "Django secret key",
      "generator": "secret"
    },
    "ALLOWED_HOSTS": "*",
    "SECURE_PROXY_SSL_HEADER": "HTTP_X_FORWARDED_PROTO,https"
  },
  "formation": {
    "web": {
      "quantity": 1,
      "size": "basic"
    }
  },
  "environments": {
    "test": {
      "addons": ["heroku-postgresql:in-dyno"],
      "scripts": {
        "test-setup": "python manage.py collectstatic --no-input",
        "test": "flake8 && pytest"
      }
    }
  }
}
EOL

# add heroku stuff to flake8 exclude
sed -i '/\[tool\.flake8\]/a exclude = [\n    ".heroku",\n    ".local",\n]' pyproject.toml

# Commit the changes
git add --all
git commit -m "Configure the project for Heroku deployment"
