#!/bin/bash

set -euo pipefail

# Add robots.txt view to urls.py
sed -i "/from django.urls import/a\from django.http import HttpResponse" "${DJANGO_PROJECT_NAME}/urls.py"
sed -i "/urlpatterns = \[/a\    path('robots.txt', lambda r: HttpResponse(\"User-agent: *\\\\nDisallow: /\\\\n\", content_type=\"text/plain\"))," "${DJANGO_PROJECT_NAME}/urls.py"

# Add test for robots.txt
cat << EOF >> "${DJANGO_PROJECT_NAME}/test_no_smoke.py"

def test_robots_txt(client):
    response = client.get('/robots.txt')
    assert response.status_code == 200
    assert response['Content-Type'] == "text/plain"
EOF

poetry run isort .
git add --all
git commit -m "feat: Add robots.txt view and test"
