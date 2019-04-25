# -*- coding: utf-8 -*-
"""
Created on Sun Apr 21 22:53:46 2019

@author: user
"""

from flask import Flask,render_template,url_for,request

app = Flask(__name__)

@app.route('/')

def home():
    return 'Hello World Ha ha ha'


if __name__ == '__main__':
    app.run(debug = True)