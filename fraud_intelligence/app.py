# fraud_intelligence/app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/fraud_data', methods=['GET'])
def get_fraud_data():
    # Mock data - in a real scenario, this would fetch from an external source
    return jsonify({
        "ip_blacklist": ["192.168.1.1", "10.0.0.1"],
        "suspicious_cards": ["4111111111111111", "5500000000000004"]
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)