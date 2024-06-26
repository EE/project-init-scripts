# Check if the current directory is already a Git repository
if [ -d ".git" ]; then
  echo "Current directory is already a Git repository."
  exit 1
fi

# Initialize a new Git repository
git init

git commit --allow-empty -m "Initial commit"
