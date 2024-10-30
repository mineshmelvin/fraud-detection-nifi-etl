package com.melvin

import org.apache.spark.sql.functions.{col, from_json}
import org.apache.spark.sql.streaming.Trigger
import org.apache.spark.sql.types._
import org.apache.spark.sql.{DataFrame, SparkSession}
object KafkaIntegration {

  // Define schema for JSON messages from Kafka
  private val transactionSchema = new StructType()
    .add("transaction_datetime", StringType)
    .add("merchant", StringType)
    .add("category", StringType)
    .add("amount", FloatType)
    .add("city", StringType)
    .add("state", StringType)
    .add("latitude", FloatType)
    .add("longitude", FloatType)
    .add("city_population", IntegerType)
    .add("job", StringType)
    .add("date_of_birth", StringType)
    .add("trans_num", StringType)
    .add("merchant_latitude", FloatType)
    .add("merchant_longitude", FloatType)
    .add("is_flagged_fraud", IntegerType)

  def readFromKafka(kafka_servers: String, topic: String)(implicit spark: SparkSession): DataFrame = {
    val transactionsDF = spark.readStream
      .format("kafka")
      .option("kafka.bootstrap.servers", kafka_servers)
      .option("subscribe", topic)
      .option("startingOffsets", "latest")
      .load()
      .selectExpr("CAST(value AS STRING)")

    // Parse JSON data and apply schema
    val parsedDF = transactionsDF
      .select(from_json(col("value"), transactionSchema).as("data"))
      .select("data.*")

    parsedDF
  }

  def writeToKafka(df: DataFrame, bootstrapServers: String, topic: String, query_name: String): Unit = {
    df
      .selectExpr("CAST(trans_num AS STRING) AS key", "to_json(struct(*)) AS value")
      .writeStream
      .format("kafka")
      .option("kafka.bootstrap.servers", bootstrapServers)
      .option("topic", topic)
      .option("checkpointLocation", "spark_checkpoint")
      .outputMode("append")
      .queryName(query_name)
      .trigger(Trigger.ProcessingTime("10 seconds"))
      .start()
  }
}