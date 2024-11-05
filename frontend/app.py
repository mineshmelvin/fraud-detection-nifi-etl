from flask import Flask, render_template, request, jsonify
import psycopg2
from datetime import datetime
import pytz

app = Flask(__name__)

# Database configuration
DATABASE = "the_melvin_bank_db"
USER = "postgres"
PASSWORD = "adminpassword"
HOST = "postgres"
PORT = "5432"


# Connect to PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        dbname=DATABASE,
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT
    )
    return conn


@app.route('/')
def index():
    return render_template('index.html')


@app.before_request
def log_request_info():
    print("Request headers: %s", request.headers)
    print("Request body: %s", request.get_data())


@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.get_json()
    print("Received data:", data)
    conn = get_db_connection()
    cursor = conn.cursor()  # Create a cursor explicitly
    try:
        username = data['username']
        email = data['email']
        phone = data['phone']
        address = data['address']
        city = data['city']
        state = data['state']
        country = data['country']
        postal_code = data['postal_code']
        dob_str = data['dob']
        dob = datetime.strptime(dob_str, '%Y-%m-%d').date()
        profile_picture_url = data['profile_picture_url']

        # Insert query (user_id is auto-incremented)
        insert_query = """
        INSERT INTO users (username, email, phone, address, city, state, country, postal_code, dob, profile_picture_url)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING user_id;
        """

        # Execute the insert query
        cursor.execute(insert_query,
                       (username, email, phone, address, city, state, country, postal_code, dob, profile_picture_url))
        user_id = cursor.fetchone()[0]
        conn.commit()  # Commit the transaction
        return jsonify({"message": "User added successfully", "user_id": user_id}), 201
    except Exception as e:
        conn.rollback()  # Rollback the transaction on error
        return jsonify({"error": str(e)}), 400
    finally:
        cursor.close()  # Close the cursor
        conn.close()  # Close the connection


@app.route('/add_transaction', methods=['POST'])
def add_transaction():
    data = request.get_json()

    local_timezone = pytz.timezone('Asia/Calcutta')
    utc_now = datetime.now(pytz.utc)

    transaction_datetime = utc_now.astimezone(local_timezone).strftime('%Y-%m-%d %H:%M:%S')
    merchant = data['merchant']
    category = data['category']
    amount = data['amount']
    latitude = data['latitude']
    longitude = data['longitude']
    merchant_latitude = data['mlatitude']
    merchant_longitude = data['mlongitude']
    currency = data['currency']
    user_id = data['user_id']

    conn = get_db_connection()
    cursor = conn.cursor()
    insert_query = """
        INSERT INTO transactions (transaction_datetime,merchant,category,amount,latitude,longitude,merchant_latitude,merchant_longitude,currency,user_id)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING transaction_id;
    """

    # Execute the insert query
    try:
        cursor.execute(insert_query, (
            transaction_datetime, merchant, category, amount, latitude, longitude, merchant_latitude,
            merchant_longitude,
            currency, user_id))
        transaction_id = cursor.fetchone()[0]
        conn.commit()  # Commit the transaction
        return jsonify({"message": "Transaction added successfully", "transaction_id": transaction_id}), 201
    except Exception as e:
        conn.rollback()  # Rollback the transaction on error
        return jsonify({"error": str(e)}), 400
    finally:
        cursor.close()  # Close the cursor


if __name__ == '__main__':
    app.run(debug=True)
