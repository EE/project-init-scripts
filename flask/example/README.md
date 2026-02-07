# example

## Python dependencies

This project uses Poetry for dependency management. To install the dependencies, run:

    poetry install

To activate the virtual environment, run:

    poetry shell

## Environment Variables

Configure quick-start env vars:

    cp example.env .env

## Database Migrations

Create a new migration:

    poetry run flask db migrate -m "Description"

Apply migrations:

    poetry run flask db upgrade
