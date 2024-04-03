#!/usr/bin/env python3

from flask import Flask, request, jsonify, render_template
import boto3

app = Flask(__name__)
client = boto3.client('s3')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/boto')
def boto():
  buckets = client.list_buckets()
  return jsonify(buckets)
