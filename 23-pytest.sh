poetry add --group dev 'pytest==*'

cat >> pyproject.toml <<EOL

[tool.pytest.ini_options]
python_files = ["tests.py", "test_*.py", "*_tests.py"]
EOL

git add --all
git commit -m "Install and configure pytest"
