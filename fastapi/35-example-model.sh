#!/bin/bash

# This step adds an example SQLAlchemy model with CRUD routes and tests
# using a real PostgreSQL database.
# It is NOT included in everything.sh — it exists solely to verify
# that the scaffolded app can easily be extended with new models.

# Determine project name if not set
if [[ -z "$FASTAPI_PROJECT_NAME" ]]; then
    FASTAPI_PROJECT_NAME=$(basename "$PWD")
    FASTAPI_PROJECT_NAME=${FASTAPI_PROJECT_NAME//[-.]/_}
    export FASTAPI_PROJECT_NAME
fi

# Install pytest-asyncio for async test support
poetry add --group dev 'pytest-asyncio==*'

# Create example SQLAlchemy model with routes
cat > "$FASTAPI_PROJECT_NAME/example.py" <<EOF
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy import String, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Mapped, mapped_column

from .database import Base, get_db

router = APIRouter(prefix="/examples", tags=["examples"])


class Example(Base):
    __tablename__ = "examples"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String, index=True)
    description: Mapped[str | None] = mapped_column(String, nullable=True)


class ExampleCreate(BaseModel):
    name: str
    description: str | None = None


class ExampleRead(BaseModel):
    id: int
    name: str
    description: str | None = None

    model_config = {"from_attributes": True}


@router.post("", response_model=ExampleRead)
async def create_example(item: ExampleCreate, db: AsyncSession = Depends(get_db)):
    example = Example(**item.model_dump())
    db.add(example)
    await db.commit()
    await db.refresh(example)
    return example


@router.get("", response_model=list[ExampleRead])
async def list_examples(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Example))
    return result.scalars().all()
EOF

# Register example router in main.py
sed -i '/^from fastapi import FastAPI/a from .example import router as example_router' "$FASTAPI_PROJECT_NAME/main.py"
sed -i '/^app = FastAPI()/a app.include_router(example_router)' "$FASTAPI_PROJECT_NAME/main.py"

# Import example models in alembic env so migrations pick them up
sed -i "/from $FASTAPI_PROJECT_NAME.models import/a from $FASTAPI_PROJECT_NAME.example import *  # noqa: F401, F403" "alembic/env.py"

# Create conftest.py with async DB fixtures
cat > "conftest.py" <<EOF
import pytest
from httpx import ASGITransport, AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from $FASTAPI_PROJECT_NAME.config import settings
from $FASTAPI_PROJECT_NAME.database import Base, get_db
from $FASTAPI_PROJECT_NAME.main import app


@pytest.fixture
async def db():
    engine = create_async_engine(settings.database_url)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with async_session() as session:
        yield session

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    await engine.dispose()


@pytest.fixture
async def client(db):
    async def override_get_db():
        yield db

    app.dependency_overrides[get_db] = override_get_db
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac
    app.dependency_overrides.clear()
EOF

# Replace test file with async tests using real DB
cat > "test_app.py" <<EOF
from sqlalchemy import select

from $FASTAPI_PROJECT_NAME.example import Example


async def test_root(client):
    response = await client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello, World!"}


async def test_health(client):
    response = await client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


async def test_create_example(client, db):
    response = await client.post(
        "/examples", json={"name": "test", "description": "a test item"},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "test"
    assert data["description"] == "a test item"
    assert "id" in data

    result = await db.execute(select(Example).where(Example.id == data["id"]))
    assert result.scalar_one().name == "test"


async def test_list_examples(client, db):
    db.add(Example(name="list test"))
    await db.commit()

    response = await client.get("/examples")
    assert response.status_code == 200
    items = response.json()
    assert isinstance(items, list)
    assert any(item["name"] == "list test" for item in items)
EOF

# Configure pytest-asyncio mode
sed -i '/\[tool\.pytest\.ini_options\]/a asyncio_mode = "auto"' pyproject.toml

poetry run isort .
git add --all
git commit -m "Add example model to demonstrate app extensibility"
