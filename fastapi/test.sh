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
"$original_dir/fastapi/everything.sh"
source "$original_dir/fastapi/35-example-model.sh"

poetry run flake8
cp example.env .env
poetry run pytest

# remove the virtual env, it may be stored outside the temporary directory
poetry env remove --all

# Navigate back to the original directory
popd

echo "All good!"
