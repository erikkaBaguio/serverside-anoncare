from flask import Flask
import os

app = Flask(__name__)
app.debug = True


from app import views


if __name__ == '__main__':
    app.run()
