# Install django-environ
poetry add 'django-environ=*'

# Patch the settings.py file with configurable stuff using django-environ
sed -i "/from pathlib import Path/a import environ" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "/BASE_DIR = /a env = environ.Env()\nenv.read_env(str(BASE_DIR / '.env'))" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/SECRET_KEY = .*/SECRET_KEY = env.str('SECRET_KEY')/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/DEBUG = .*/DEBUG = env.bool('DEBUG', default=False)/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/ALLOWED_HOSTS = .*/ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[])/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "/DATABASES = {/,/^}/c DATABASES = {\n    'default': env.db('DATABASE_URL')\n}" "$DJANGO_PROJECT_NAME/settings.py"

cat <<EOF > example.env
SECRET_KEY=your_secret_key
DEBUG=True
DATABASE_URL=postgresql://localhost/$POETRY_PROJECT_NAME
EOF

# Add .env to .gitignore
echo ".env" >> .gitignore

# make our .env file
cp example.env .env

# describe in the README
cat <<EOF >> "README.md"

## Environment Variables

Configure quick-start env vars

    cp example.env .env
EOF

poetry run isort .
git add --all
git commit -m "Configure Django settings with django-environ"
