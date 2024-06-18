#!/bin/bash

# recreate the example directory
rm -rf example
mkdir -p example

# Navigate to the example directory
pushd example

# Execute the initialization scripts
../everything.sh

# dump all commits to file, so it can be inspected by our visitors
git log --format='%n--- %s' --stat --reverse > commits.txt

# Navigate back to the original directory
popd

# make sure exmple project is not a git repo, becuase we want it under our vc
rm -rf example/.git

echo "Example project initialized successfully!"
