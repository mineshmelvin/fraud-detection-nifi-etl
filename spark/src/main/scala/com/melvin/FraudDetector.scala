package com.melvin

import com.melvin.KafkaIntegration.{readFromKafka, writeToKafka}
import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.ml.feature.StringIndexer
import org.apache.spark.sql.functions.col
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

    spark.sparkContext.setLogLevel("WARN")

    val KAFKA_SERVERS = "172.22.72.148:9092"
    val INPUT_KAFKA_TOPIC = "transaction_events"
    val OUTPUT_FRAUD_KAFKA_TOPIC = "fraud_alerts"
    val OUTPUT_PROCESSED__KAFKA_TOPIC = "processed_transactions"
    val FLAGGED_KEYSPACE = "fraud_detection"
    val FLAGGED_TABLE = "flagged_transactions"

    // Load the fraud detection model
    //val fraudDetectionModel = new FraudDetectionModel(spark)
    val fraudDetectionModel = PipelineModel.load("src/main/scala/FraudDetectionModel")

    // Read from Kafka topic 'transactions'
    val parsedTransactionsDF = readFromKafka(KAFKA_SERVERS, INPUT_KAFKA_TOPIC)

    // Enrich data with geolocation info
    // val enrichedDF = enrichWithGeolocation(parsedTransactionsDF)
    val columnsToIndex = Seq("merchant", "category", "job") // Add all columns you want to index

    // Create a list of indexers for each column
    val indexers = columnsToIndex.map { colName =>
      new StringIndexer()
        .setInputCol(colName)
        .setOutputCol(s"${colName}Index")
        .setHandleInvalid("keep")
    }

    // Create a Pipeline with the indexers
    val pipeline = new Pipeline().setStages(indexers.toArray)

    // Fit the indexers and transform the DataFrame
    //val indexedDF = pipeline.fit(parsedTransactionsDF).transform(parsedTransactionsDF)

    // Score transactions for fraud
    //val featuresDF = parsedTransactionsDF.withColumn("features", struct("merchant", "category", "latitude", "longitude", "merchant_latitude", "merchant_longitude"))
    val scoredDF = fraudDetectionModel.transform(parsedTransactionsDF).withColumn("fraud_score", col("prediction")) //scoreTransactions(patternsDF)

    // Separate flagged transactions
    val flaggedTransactions = scoredDF.filter(col("fraud_score") > 0.7)

    // Write flagged transactions to Kafka for real-time monitoring
    //writeToKafka(flaggedTransactions, KAFKA_SERVERS, OUTPUT_FRAUD_KAFKA_TOPIC, "flagging")
    writeToKafka(scoredDF, KAFKA_SERVERS, OUTPUT_PROCESSED__KAFKA_TOPIC, "fraud_detection")

    // Write flagged transactions to Cassandra
    //writeToCassandra(flaggedTransactions, FLAGGED_KEYSPACE, FLAGGED_TABLE)

    // Await termination
    spark.streams.active.foreach(query => {
      println(s"Active query: ${query.name} is running.")
      //query.stop() // Stop existing queries
      query.awaitTermination() // Wait for it to finish
    })
  }
}