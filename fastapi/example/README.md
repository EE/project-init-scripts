# example

## Python dependencies

This project uses Poetry for dependency management. To install the dependencies, run:

    poetry install

To activate the virtual environment, run:

    poetry shell

## Environment Variables

Configure quick-start env vars:

    cp example.env .env

## Running the Application

Start the development server:

    poetry run uvicorn example.main:app --reload

The API will be available at http://localhost:8000

## Database Migrations

Create a new migration:

    poetry run alembic revision --autogenerate -m "Description"

Apply migrations:

    poetry run alembic upgrade head
