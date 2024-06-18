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
    "ALLOWED_HOSTS": "*"
  },
  "formation": {
    "web": {
      "quantity": 1,
      "size": "basic"
    }
  }
}
EOL

# Commit the changes
git add --all
git commit -m "Configure the project for Heroku deployment"
