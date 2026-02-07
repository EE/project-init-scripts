#!/bin/bash

# Install Flask-Admin
poetry add 'flask-admin==*'

# Add Flask-Admin initialization to app.py
sed -i '/^from flask_migrate import Migrate/a from flask_admin import Admin' app.py
sed -i '/^migrate = Migrate(app, db)/a admin = Admin(app)' app.py

poetry run isort .
git add --all
git commit -m "Install and configure Flask-Admin"
