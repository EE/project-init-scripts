# Check if Poetry is installed
if ! command -v poetry &> /dev/null
then
    echo "Poetry is not installed. Please install Poetry and try again."
    exit 1
fi

# Check if the POETRY_PROJECT_NAME environment variable is set
if [[ -z "$POETRY_PROJECT_NAME" ]]; then
    echo "POETRY_PROJECT_NAME environment variable is not set. Using the current directory name as the project name."
    POETRY_PROJECT_NAME=$(basename "$PWD")
    export POETRY_PROJECT_NAME
fi

# Initialize a new Poetry project with the project name
poetry init --name "$POETRY_PROJECT_NAME" --no-interaction

# Switch to non-package-mode
sed -i '/^version =/c package-mode = false' pyproject.toml

# Create an empty virtual environment
poetry install

# add python stuff to gitignore
echo "__pycache__/" >> .gitignore

git add --all
git commit -m "Initialize Poetry environment"

# Print success message
echo "Empty Poetry environment initialized successfully with project name: $POETRY_PROJECT_NAME"
