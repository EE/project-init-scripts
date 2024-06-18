#!/bin/bash

# Create a temporary directory
tmp_dir=$(mktemp -d)

# Store the current directory
original_dir=$(pwd)

# Navigate to the temporary directory
pushd "$tmp_dir"

# Execute the pipeline script from the original directory
"$original_dir/everything.sh"
success=$?

# Navigate back to the original directory
popd

# Remove the temporary directory
rm -rf "$tmp_dir"

if [ $success -ne 0 ]; then
    echo "Testing failed!"
    exit 1
else
    echo "Testing completed successfully!"
fi
