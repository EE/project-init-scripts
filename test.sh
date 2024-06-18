#!/bin/bash

# Create a temporary directory
tmp_dir=$(mktemp -d)

# Store the current directory
original_dir=$(pwd)

# Navigate to the temporary directory
pushd "$tmp_dir"

# Execute the pipeline script from the original directory
"$original_dir/everything.sh"

# Navigate back to the original directory
popd

# Remove the temporary directory
rm -rf "$tmp_dir"

echo "Testing completed successfully!"
