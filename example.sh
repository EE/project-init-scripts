#!/bin/bash

# recreate the example directory
rm -rf example
mkdir -p example

# Navigate to the example directory
pushd example

# Execute the initialization scripts
../everything.sh

# Navigate back to the original directory
popd

echo "Example project initialized successfully!"
