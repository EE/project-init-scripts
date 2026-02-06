#!/bin/bash

# This step adds an example model with CRUD routes and tests.
# It is NOT included in everything.sh — it exists solely to verify
# that the scaffolded app can easily be extended with new models.

# Determine project name if not set
if [[ -z "$FASTAPI_PROJECT_NAME" ]]; then
    FASTAPI_PROJECT_NAME=$(basename "$PWD")
    FASTAPI_PROJECT_NAME=${FASTAPI_PROJECT_NAME//[-.]/_}
    export FASTAPI_PROJECT_NAME
fi

# Create example model with router
cat > "$FASTAPI_PROJECT_NAME/example.py" <<EOF
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(prefix="/examples", tags=["examples"])

_examples_db: dict[int, "ExampleItem"] = {}
_next_id: int = 1


class ExampleItemCreate(BaseModel):
    name: str
    description: str | None = None


class ExampleItem(BaseModel):
    id: int
    name: str
    description: str | None = None


@router.post("", response_model=ExampleItem)
async def create_example(item: ExampleItemCreate):
    global _next_id
    example = ExampleItem(id=_next_id, **item.model_dump())
    _examples_db[_next_id] = example
    _next_id += 1
    return example


@router.get("", response_model=list[ExampleItem])
async def list_examples():
    return list(_examples_db.values())


@router.get("/{item_id}", response_model=ExampleItem)
async def get_example(item_id: int):
    if item_id not in _examples_db:
        raise HTTPException(status_code=404, detail="Example not found")
    return _examples_db[item_id]
EOF

# Register example router in main.py
sed -i '/^from fastapi import FastAPI/a from .example import router as example_router' "$FASTAPI_PROJECT_NAME/main.py"
sed -i '/^app = FastAPI()/a app.include_router(example_router)' "$FASTAPI_PROJECT_NAME/main.py"

# Add example model import to test file
sed -i "/^from ${FASTAPI_PROJECT_NAME}.main import app/a from ${FASTAPI_PROJECT_NAME}.example import ExampleItem, _examples_db" "test_app.py"

# Add example model tests
cat >> "test_app.py" <<EOF


def test_create_example():
    response = client.post("/examples", json={"name": "test", "description": "a test item"})
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "test"
    assert data["description"] == "a test item"
    assert "id" in data
    assert data["id"] in _examples_db


def test_list_examples():
    response = client.get("/examples")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_get_example():
    item = ExampleItem(id=999, name="lookup test")
    _examples_db[999] = item

    response = client.get("/examples/999")
    assert response.status_code == 200
    assert response.json()["name"] == "lookup test"


def test_get_example_not_found():
    response = client.get("/examples/99999")
    assert response.status_code == 404
EOF

poetry run isort .
git add --all
git commit -m "Add example model to demonstrate app extensibility"
