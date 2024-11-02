-- cassandra/init.cql
--CREATE USER 'admin' WITH PASSWORD 'password' SUPERUSER;
CREATE KEYSPACE IF NOT EXISTS fraud_detection
WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

--GRANT ALL ON KEYSPACE fraud_detection TO 'admin';

USE fraud_detection;

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id BIGINT,
    transaction_datetime TIMESTAMP,
    merchant TEXT,
    category TEXT,
    amount FLOAT,
    latitude FLOAT,
    longitude FLOAT,
    merchant_latitude FLOAT,
    merchant_longitude FLOAT,
    is_fraud INT,
    currency TEXT,
    user_id INT,
    PRIMARY KEY (is_fraud, transaction_datetime, transaction_id)
) WITH CLUSTERING ORDER BY (transaction_datetime DESC);

COPY fraud_detection.transactions (transaction_id,transaction_datetime,merchant,category,amount,latitude,longitude,merchant_latitude,merchant_longitude,is_fraud,currency,user_id
) FROM '/home/new_credit_card_fraud.csv' WITH HEADER = TRUE;