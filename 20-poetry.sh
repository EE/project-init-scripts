#!/bin/bash

# Check if Poetry is installed
if ! command -v poetry &> /dev/null
then
    echo "Poetry is not installed. Please install Poetry and try again."
    exit 1
fi

# Check if the POETRY_PROJECT_NAME environment variable is set
if [[ -z "$POETRY_PROJECT_NAME" ]]; then
    echo "POETRY_PROJECT_NAME environment variable is not set. Using the current directory name as the project name."
    POETRY_PROJECT_NAME=$(basename "$PWD" | tr '.' '-')
    export POETRY_PROJECT_NAME
fi

# Initialize a new Poetry project with the project name
poetry init --name "$POETRY_PROJECT_NAME" --python ">=3.14,<4" --no-interaction

# Modify the existing [tool.poetry] section to add package-mode = false
sed -i '/^\[tool.poetry\]/a package-mode = false' pyproject.toml

echo "__pycache__/" >> .gitignore

cat <<EOF >> "README.md"
# $POETRY_PROJECT_NAME

## Python dependencies

This project uses Poetry for dependency management. To install the dependencies, run:

    poetry install

To activate the virtual environment, run:

    poetry shell
EOF

git add --all
git commit -m "Initialize Poetry environment"
