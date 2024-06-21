# install and configure sentry

poetry add 'sentry-sdk[django]==*'


# put some settings to configure sentry

sed -i "/import environ/a import sentry_sdk" "$DJANGO_PROJECT_NAME/settings.py"

cat <<EOF >> "$DJANGO_PROJECT_NAME/settings.py"

SENTRY_DSN = env.str('SENTRY_DSN', default='')
if SENTRY_DSN:
    sentry_sdk.init(
        dsn=SENTRY_DSN,
        traces_sample_rate=0.01,
    )
EOF

poetry run isort .

git add --all
git commit -m "Install and configure Sentry"
