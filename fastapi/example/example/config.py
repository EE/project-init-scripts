from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    debug: bool = False
    database_url: str = "postgresql+asyncpg://localhost/app"
    secret_key: str = "changeme"
    sentry_dsn: str = ""
    sentry_traces_sample_rate: float = 0.01


settings = Settings()
