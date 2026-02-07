#!/bin/bash

# Install python-dotenv for environment configuration
poetry add 'python-dotenv==*'

# Create example.env file
cat <<EOF > example.env
DEBUG=True
DATABASE_URL=postgresql://localhost/$POETRY_PROJECT_NAME
SECRET_KEY=your_secret_key_here
EOF

# Add .env to .gitignore
echo ".env" >> .gitignore

# Add to README
cat <<EOF >> "README.md"

## Environment Variables

Configure quick-start env vars:

    cp example.env .env
EOF

git add --all
git commit -m "Install python-dotenv and configure environment"
