from flask import Flask, request
import requests

app = Flask(__name__)

url = "http://localhost:80/json"

def get_full_url():
    return url

@app.route('/json')
def send_json_request():
    url = get_full_url()
    response = requests.get(url)
    return f"Status Code: {response.status_code}<br>Response Content: {response.text}"

@app.route('/xml')
def send_xml_request():
    url = get_full_url()
    response = requests.get(url)
    return f"Status Code: {response.status_code}<br>Response Content: {response.text}"

@app.route('/csv')
def send_csv_request():
    url = get_full_url()
    response = requests.get(url)
    return f"Status Code: {response.status_code}<br>Response Content: {response.text}"

@app.route('/yaml')
def send_yaml_request():
    url = get_full_url()
    response = requests.get(url)
    return f"Status Code: {response.status_code}<br>Response Content: {response.text}"

@app.route('/text')
def send_text_request():
    url = get_full_url()
    response = requests.get(url)
    return f"Status Code: {response.status_code}<br>Response Content: {response.text}"

if __name__ == '__main__':
    app.run(debug=True)
