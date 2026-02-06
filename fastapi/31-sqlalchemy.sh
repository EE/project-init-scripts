#!/bin/bash

# Install SQLAlchemy with async support
poetry add 'sqlalchemy[asyncio]==*'
poetry add 'asyncpg==*'

# Create database configuration module
cat > "$FASTAPI_PROJECT_NAME/database.py" <<EOF
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from .config import settings

engine = create_async_engine(settings.database_url, echo=settings.debug)

async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


class Base(DeclarativeBase):
    pass


async def get_db():
    async with async_session() as session:
        try:
            yield session
        finally:
            await session.close()
EOF

# Create models module
cat > "$FASTAPI_PROJECT_NAME/models.py" <<EOF
from .database import Base  # noqa: F401
EOF

poetry run isort .
git add --all
git commit -m "Install and configure SQLAlchemy with async support"
