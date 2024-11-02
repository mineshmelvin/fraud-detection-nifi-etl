# Cassandra Dockerfile
FROM bitnami/cassandra:latest

# Optional: You can add any custom configurations or initialization scripts here
COPY ./new_credit_card_fraud.csv /home/new_credit_card_fraud.csv
COPY ./init.cql /docker-entrypoint-initdb.d/init.cql
COPY ../config.properties /config.properties

EXPOSE 9042 7000 7001

ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]