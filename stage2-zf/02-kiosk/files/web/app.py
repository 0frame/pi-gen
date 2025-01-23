from flask import Flask, request, render_template, redirect, jsonify
import subprocess

app = Flask(__name__)

# Enable debug mode to display errors on the web page
# app.debug = True

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/check-network', methods=['GET'])
def check_network():
    # Check if the device is connected to the internet, return json response
    # with status code 200 if connected, 500 if not connected
    # Use the 'ping' command to check if the device is connected to the internet
    try:
        subprocess.run(['ping', '-c', '1', '-W', '1', '8.8.8.8'], check=True)
        return jsonify({"connected": True}), 200

    except subprocess.CalledProcessError as e:
        return jsonify({"connected": False}), 200

@app.route('/list-ssids', methods=['GET'])
def list_ssids():
    # Use NetworkManager CLI (nmcli) to list available WiFi networks
    try:
        result = subprocess.run(['nmcli', 'dev', 'wifi', 'list'], check=True, stdout=subprocess.PIPE)
        ssids = result.stdout.decode('utf-8').split('\n')[1:]

        return {'ssids': ssids}, 200

    except subprocess.CalledProcessError as e:
        return f"Failed to list SSIDs: {e}", 500


@app.route('/configure', methods=['POST'])
def configure_wifi():
    ssid = request.json.get('ssid')
    password = request.json.get('password')

    if not ssid or not password:
        return jsonify({"success": False, "error": "SSID and Password are required."}), 400

    try:
        # Use NetworkManager CLI (nmcli) to configure the WiFi network
        subprocess.run([
            'nmcli', 'dev', 'wifi', 'connect', ssid, 'password', password
        ], check=True)

        return jsonify({"success": True, "message": "WiFi configuration updated successfully!"})

    except subprocess.CalledProcessError as e:
        return jsonify({"success": False, "error": f"Failed to configure WiFi: {e}"}), 500

# Add route that shuts down the flask server
@app.route('/shutdown', methods=['POST'])
def shutdown():
    # log the action
    print('Server shutting down...')
    # run subprocess to shutdown the flask server
    subprocess.run(['pkill', 'python'])
    return 'Server shutting down...'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
