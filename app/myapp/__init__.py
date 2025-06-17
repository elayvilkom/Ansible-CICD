import os
from flask import Flask
from .extensions import db
from .routes import main

def create_app():
    app = Flask(__name__)
    db.init_app(app)
    app.register_blueprint(main)

    with app.app_context():
        db.create_all()

    return app
