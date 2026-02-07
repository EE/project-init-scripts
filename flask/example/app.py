import os

from dotenv import load_dotenv
from flask import Flask
from flask_admin import Admin
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy


load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'changeme')
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ['DATABASE_URL']

db = SQLAlchemy(app)
migrate = Migrate(app, db)
admin = Admin(app)


@app.route('/')
def index():
    return 'Hello, World!'
