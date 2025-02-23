#!/bin/bash

# Install Flask
poetry add 'flask==*'

# Create the main application file
cat > "app.py" <<EOF
from flask import Flask


app = Flask(__name__)


@app.route('/')
def index():
    return 'Hello, World!'


if __name__ == '__main__':
    app.run()
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
