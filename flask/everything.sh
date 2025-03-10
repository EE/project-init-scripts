#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status
set -o pipefail # Prevent errors in a pipeline from being masked

# Get the directory path of the current script
script_dir=$(dirname "$0")

# Execute the initialization scripts
source "$script_dir/../10-git.sh"
source "$script_dir/../20-poetry.sh"
source "$script_dir/../21-flake.sh"
source "$script_dir/../22-isort.sh"
source "$script_dir/../23-pytest.sh"
source "$script_dir/30-flask.sh"
