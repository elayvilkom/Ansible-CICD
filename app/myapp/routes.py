from flask import Blueprint, render_template, redirect, url_for, request
from .models import User
from .extensions import db

main = Blueprint('main', __name__)

@main.route('/')
def home():
    return render_template('home.html') 
    
@main.route('/add', methods=['POST'])
def add_user():
    username = request.form.get("username")
    if username:
        db.session.add(User(username=username))
        db.session.commit()
    return redirect(url_for("main.show_users"))

@main.route('/users')
def show_users():
    users = User.query.all()
    return f"<ul>{''.join([f'<li>{user.username}</li>' for user in users])}</ul>"
