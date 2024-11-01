package com.melvin

import com.melvin.CassandraIntegration.writeToCassandra
import com.melvin.KafkaIntegration.{readFromKafka, writeToKafka}
import org.apache.spark.ml.PipelineModel
import org.apache.spark.sql.functions.{col, lit, when}
import org.apache.spark.sql.SparkSession

/**
 * @author Minesh Melvin
 */
object FraudDetector {
  def main(args: Array[String]): Unit = {
    implicit val spark: SparkSession = SparkSession.builder
      .master("local[*]")
      .appName("Real-time Fraud Detection")
      .getOrCreate()

    import spark.implicits._
    spark.sparkContext.setLogLevel("WARN")

    val KAFKA_SERVERS = "172.22.72.148:9092"
    val INPUT_KAFKA_TOPIC = "transactions"
    val OUTPUT_FRAUD_KAFKA_TOPIC = "fraud_alerts"
    val OUTPUT_PROCESSED__KAFKA_TOPIC = "processed_transactions"
    val FLAGGED_KEYSPACE = "fraud_detection"
    val FLAGGED_TABLE = "transactions"

    // Load the fraud detection model
    val fraudDetectionModel = PipelineModel.load("src/main/scala/FraudDetectionModel")

    // Read from Kafka topic 'transactions'
    val parsedTransactionsDF = readFromKafka(KAFKA_SERVERS, INPUT_KAFKA_TOPIC)

    // Score transactions for fraud
    val scoredDF = fraudDetectionModel.transform(parsedTransactionsDF)
      .withColumn("fraud_score", col("prediction"))
      .withColumn("is_fraud", when($"fraud_score" > 0.8, lit(1)).otherwise(lit(0)))

    // Separate flagged transactions
    val requiredDF = scoredDF
      .select("transaction_id", "transaction_datetime", "merchant", "category", "amount", "latitude",
                  "longitude", "merchant_latitude", "merchant_longitude", "currency", "user_id", "is_fraud")

    val fraudTransactions = requiredDF.where($"is_fraud" === 1)

    // Write flagged transactions to Kafka for real-time monitoring
    writeToKafka(fraudTransactions, KAFKA_SERVERS, OUTPUT_FRAUD_KAFKA_TOPIC, "flagging")
    writeToKafka(requiredDF, KAFKA_SERVERS, OUTPUT_PROCESSED__KAFKA_TOPIC, "fraud_detection")

    // Write flagged transactions to Cassandra
    writeToCassandra(fraudTransactions, FLAGGED_KEYSPACE, FLAGGED_TABLE)

    // Await termination
    spark.streams.active.foreach(query => {
      println(s"Active query: ${query.name} is running.")
      query.awaitTermination() // Wait for it to finish
    })
  }
}