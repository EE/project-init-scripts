# put some settings to force HTTPS

cat <<EOF >> "$DJANGO_PROJECT_NAME/settings.py"

# enforce https traffic
FORCE_HTTPS = env.bool('FORCE_HTTPS', default=True)
if FORCE_HTTPS:
    SECURE_SSL_REDIRECT = True
    SECURE_HSTS_SECONDS = 60 * 60 * 24 * 365  # 1 year
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SECURE = True
    SECURE_PROXY_SSL_HEADER = env.list('SECURE_PROXY_SSL_HEADER')
EOF

echo FORCE_HTTPS=False >> example.env

git add --all
git commit -m "Force HTTPS traffic"
