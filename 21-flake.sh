# Install Flake8 and flake8-pyproject
poetry add --group dev 'flake8==*' 'flake8-pyproject==*'

# update the pyproject.toml file with Flake8 configuration
cat >> "pyproject.toml" <<EOL

[tool.flake8]
ignore = [
    "E501",  # line too long
]
EOL

poetry run flake8

echo "Flake8 installed and configured with flake8-pyproject."
