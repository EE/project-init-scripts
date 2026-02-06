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

# Create example model
cat > "$FASTAPI_PROJECT_NAME/models.py" <<EOF
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from .database import Base


class Item(Base):
    __tablename__ = "items"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String, index=True)
    description: Mapped[str | None] = mapped_column(String, nullable=True)
EOF

poetry run isort .
git add --all
git commit -m "Install and configure SQLAlchemy with async support"
