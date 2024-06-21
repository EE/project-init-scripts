#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status
set -o pipefail # Prevent errors in a pipeline from being masked

# Create a temporary directory
tmp_dir=$(mktemp -d)

trap 'rm -rf "$tmp_dir"' EXIT

# Store the current directory
original_dir=$(pwd)

# Navigate to the temporary directory
pushd "$tmp_dir"

# Execute the pipeline script from the original directory
"$original_dir/everything.sh"
success=$?

poetry run flake8
cp example.env .env
poetry run python manage.py collectstatic --no-input
poetry run pytest

# Navigate back to the original directory
popd
