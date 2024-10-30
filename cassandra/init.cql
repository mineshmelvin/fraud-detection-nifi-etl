-- cassandra/init.cql
CREATE KEYSPACE IF NOT EXISTS fraud_detection
WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE fraud_detection;

CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY,
    user_id INT,
    amount DECIMAL,
    transaction_date TIMESTAMP,
    status TEXT
);