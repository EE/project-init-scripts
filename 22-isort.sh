# Install flake8-isort
poetry add --group dev 'flake8-isort==*'

# Update the pyproject.toml file with isort configuration
cat >> "pyproject.toml" <<EOL

[tool.isort]
skip_gitignore = true
lines_after_imports = 2
# 5 = Hanging Grid Grouped
multi_line_output = 5
include_trailing_comma = true
EOL

poetry run isort .
poetry run flake8

git add --all
git commit -m "Install and configure isort with flake8-isort"
