#!/bin/bash

# Install Flask-Migrate (Alembic wrapper for Flask-SQLAlchemy)
poetry add 'flask-migrate==*'

# Add Flask-Migrate initialization to app.py
sed -i '/^from flask_sqlalchemy import SQLAlchemy/a from flask_migrate import Migrate' app.py
sed -i '/^db = SQLAlchemy(app)/a migrate = Migrate(app, db)' app.py

# Add to README
cat <<EOF >> "README.md"

## Database Migrations

Create a new migration:

    poetry run flask db migrate -m "Description"

Apply migrations:

    poetry run flask db upgrade
EOF

poetry run isort .
git add --all
git commit -m "Install and configure Flask-Migrate for database migrations"
