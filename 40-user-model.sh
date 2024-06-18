# Start a new Django app called 'users'
poetry run python manage.py startapp users

# Update the settings.py file to include the 'users' app
sed -i "/INSTALLED_APPS = \[/a \    'users'," "$DJANGO_PROJECT_NAME/settings.py"

# Create a custom user model with UUID4 as the primary key
cat > users/models.py <<EOL
import uuid

from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
EOL

# remove not needed files
rm users/admin.py users/views.py users/tests.py

# Update the settings.py file to use the custom user model
echo "AUTH_USER_MODEL = 'users.User'" >> "$DJANGO_PROJECT_NAME/settings.py"

# Create initial migration for the 'users' app
poetry run python manage.py makemigrations --no-header

# Format and lint the code
poetry run isort .
poetry run flake8

# Commit the changes
git add --all
git commit -m "Custom user model using UUID4 as the primary key"
