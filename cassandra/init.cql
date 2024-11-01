-- cassandra/init.cql
CREATE KEYSPACE IF NOT EXISTS fraud_detection
WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE fraud_detection;

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT PRIMARY KEY,
    transaction_datetime TIMESTAMP,
    merchant TEXT,
    category TEXT,
    amount DECIMAL,
    latitude DECIMAL,
    longitude DECIMAL,
    merchant_latitude DECIMAL,
    merchant_longitude DECIMAL,
    is_fraud INT,
    currency TEXT,
    user_id INT
);

COPY fraud_detection.transactions (transaction_id,transaction_datetime,merchant,category,amount,latitude,longitude,merchant_latitude,merchant_longitude,is_fraud,currency,user_id
) FROM '/home/new_credit_card_fraud.csv' WITH HEADER = TRUE;