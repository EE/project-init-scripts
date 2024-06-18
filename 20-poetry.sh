#!/bin/bash

# Check if Poetry is installed
if ! command -v poetry &> /dev/null
then
    echo "Poetry is not installed. Please install Poetry and try again."
    exit 1
fi

# Initialize a new Poetry project
poetry init --no-interaction

# Switch to non-package-mode
sed -i '/^version =/c package-mode = false' pyproject.toml

# Create an empty virtual environment
poetry install

git add --all
git commit -m "Initialize Poetry environment"

# Print success message
echo "Empty Poetry environment initialized successfully!"
