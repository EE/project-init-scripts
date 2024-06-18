#!/bin/bash

# Get the directory path of the current script
script_dir=$(dirname "$0")

# Execute the initialization scripts
"$script_dir/10-git.sh"
"$script_dir/20-poetry.sh"
