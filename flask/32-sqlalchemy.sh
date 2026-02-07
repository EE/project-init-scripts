#!/bin/bash

# Install Flask-SQLAlchemy and psycopg
poetry add 'flask-sqlalchemy==*'
poetry add 'psycopg==*'

# Create models module
cat > "models.py" <<EOF
from app import db  # noqa: F401
EOF

poetry run isort .
git add --all
git commit -m "Install and configure Flask-SQLAlchemy"
