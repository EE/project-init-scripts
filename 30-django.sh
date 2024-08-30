poetry add 'django=*'
poetry add --group dev 'pytest-django==*'

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

# create pytest-django configuration
sed -i "/\[tool\.pytest\.ini_options\]/a\\
DJANGO_SETTINGS_MODULE = \"$DJANGO_PROJECT_NAME.settings\"\\
FAIL_INVALID_TEMPLATE_VARS = true" pyproject.toml

# create smoke test
cat > "test_no_smoke.py" <<EOL
import pytest
from django.urls import reverse


@pytest.mark.django_db
def test_admin_root(admin_client):
    response = admin_client.get(reverse('admin:index'))
    assert response.status_code == 200
EOL

poetry run isort .
git add --all
git commit -m "Initialize Django project"
