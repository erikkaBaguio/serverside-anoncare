from flask.ext.sqlalchemy import SQLAlchemy
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from flask.ext.mail import Mail, Message
import os
from app import app

MAIL_SERVER = 'smtp.gmail.com'
MAIL_PORT = 587
MAIL_USE_TLS = False
MAIL_USE_SSL = True
MAIL_USERNAME = 'anoncare.iit@gmail.com'
MAIL_PASSWORD = 'anoncareiit'

mail = Mail(app)


def send_email(username, email, password):
    msg = Message(
        'AnonCare Registration',
        sender='anoncare.iit@gmail.com',
        recipients=[email]
    )

    msg.body = "Username is: " + username + "\n" + "Password is: " + password
    mail.send(msg)

    return "Sent"
