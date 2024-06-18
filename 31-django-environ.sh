# Install django-environ
poetry add 'django-environ=*'

# Patch the settings.py file with configurable stuff using django-environ
sed -i "/from pathlib import Path/a \nimport environ/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "/BASE_DIR = /a env = environ.Env()\nenv.read_env(str(BASE_DIR / '.env'))" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/SECRET_KEY = .*/SECRET_KEY = env.str('DJANGO_SECRET_KEY')/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/DEBUG = .*/DEBUG = env.bool('DJANGO_DEBUG', default=False)/" "$DJANGO_PROJECT_NAME/settings.py"
sed -i "s/ALLOWED_HOSTS = .*/ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[])/" "$DJANGO_PROJECT_NAME/settings.py"

cat <<EOF > example.env
DJANGO_SECRET=your_secret_key
DJANGO_DEBUG=True
EOF

# Add .env to .gitignore
echo ".env" >> .gitignore

git add --all
git commit -m "Configure Django settings with django-environ"

echo "Django settings patched with django-environ and example.env file created."
