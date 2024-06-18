poetry add 'django=*'

# Check if the DJANGO_PROJECT_NAME environment variable is set
if [[ -z "$DJANGO_PROJECT_NAME" ]]; then
    echo "DJANGO_PROJECT_NAME environment variable is not set. Using the current directory name as the project name."
    DJANGO_PROJECT_NAME=$(basename "$PWD")
    # Replace forbiden characters in project name
    DJANGO_PROJECT_NAME=${DJANGO_PROJECT_NAME//[-.]/_}
    export DJANGO_PROJECT_NAME
fi

# Run django-admin startproject with the project name
poetry run django-admin startproject "$DJANGO_PROJECT_NAME" .

poetry run isort .
poetry run flake8
git add --all
git commit -m "Initialize Django project with project name: $DJANGO_PROJECT_NAME"
