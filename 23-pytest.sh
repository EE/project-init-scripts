poetry add --group dev 'pytest==*'

cat >> pyproject.toml <<EOL
[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = "$DJANGO_PROJECT_NAME.settings"
EOL

git add --all
git commit -m "Install and configure pytest"
