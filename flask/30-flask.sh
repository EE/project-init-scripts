#!/bin/bash

# Install Flask
poetry add 'flask==*'

# Create the main application file
cat > "app.py" <<EOF
import os

from dotenv import load_dotenv
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'changeme')
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ['DATABASE_URL']

db = SQLAlchemy(app)


@app.route('/')
def index():
    return 'Hello, World!'
EOF

# Create test file in root
cat > "app_tests.py" <<EOF
from app import app


def test_hello():
    client = app.test_client()
    response = client.get('/')
    assert response.data == b'Hello, World!'
EOF

# Basic git setup
git add --all
git commit -m "Initialize minimal Flask application"
