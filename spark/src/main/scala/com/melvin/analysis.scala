package com.melvin

import org.apache.spark.sql.functions.{lit, monotonically_increasing_id, udf}
import org.apache.spark.sql.{DataFrame, SparkSession}

object analysis extends App {
  val spark: SparkSession = SparkSession.builder.appName("FraudModelAnalysis").master("local[*]").getOrCreate()
  spark.sparkContext.setLogLevel("WARN")
  import spark.implicits._
  /**
   * .add("transaction_id", IntegerType)
   * .add("transaction_datetime", StringType)
   * .add("merchant", StringType)
   * .add("category", StringType)
   * .add("amount", FloatType)
   * .add("latitude", FloatType)
   * .add("longitude", FloatType)
   * .add("merchant_latitude", FloatType)
   * .add("merchant_longitude", FloatType)
   * .add("currency", IntegerType)
   * .add("user_id", IntegerType)
   */
  val dataPath = "C:\\Users\\mines\\workspace\\projects\\training\\FraudDetection\\src\\main\\resources\\credit_card_fraud.csv"
  val data: DataFrame = spark.read
    .option("header", "true")
    .csv(dataPath)

  private val rand = new java.util.Random

  val generateRandom = udf((start: Int) => start + rand.nextInt(21))

  val nextDF = data
    .withColumn("transaction_id", monotonically_increasing_id() + 100)
    .select("transaction_id", "transaction_datetime", "merchant", "category", "amount", "latitude", "longitude", "merchant_latitude", "merchant_longitude", "is_flagged_fraud")
    .withColumnRenamed("is_flagged_fraud", "is_fraud")
    .withColumn("currency", lit("USD"))
    .withColumn("user_id", generateRandom(lit(100)))

  nextDF.coalesce(1).write
    .option("header", "true") // Include the header
    .option("delimiter", ",") // Optional: set delimiter
    .mode("overwrite")
    .csv("src/main/resources/new_credit_card_fraud")
}