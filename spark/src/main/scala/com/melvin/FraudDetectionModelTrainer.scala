package com.melvin

import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.classification.RandomForestClassifier
import org.apache.spark.ml.evaluation.BinaryClassificationEvaluator
import org.apache.spark.ml.feature.{StringIndexer, VectorAssembler}
import org.apache.spark.sql.types._
object FraudDetectionModelTrainer extends App {

  private val fraudSchema = new StructType()
    .add("transaction_id", IntegerType)
    .add("transaction_datetime", StringType)
    .add("merchant", StringType)
    .add("category", StringType)
    .add("amount", FloatType)
    .add("latitude", FloatType)
    .add("longitude", FloatType)
    .add("merchant_latitude", FloatType)
    .add("merchant_longitude", FloatType)
    .add("is_fraud", IntegerType) // 1 = fraud, 0 = non-fraud
    .add("currency", IntegerType)
    .add("user_id", IntegerType)

  val spark: SparkSession = SparkSession.builder
    .appName("FraudModelTraining")
    .master("local[*]")
    .config("spark.cassandra.connection.host", "cassandra")
    .getOrCreate()

  spark.sparkContext.setLogLevel("WARN")

//  private val dataPath = "src/main/resources/new_credit_card_fraud.csv"
//  val data: DataFrame = spark.read
//    .schema(fraudSchema)
//    .option("header", "true")
//    .csv(dataPath)

  val data = spark.read
    .format("org.apache.spark.sql.cassandra")
    .options(Map("table" -> "transactions", "keyspace" -> "fraud_detection"))
    .load()

  // Encode categorical features using StringIndexer
  private val merchantIndexer = new StringIndexer()
    .setInputCol("merchant")
    .setOutputCol("merchantIndex")
    .setHandleInvalid("keep")

  private val categoryIndexer = new StringIndexer()
    .setInputCol("category")
    .setOutputCol("categoryIndex")
    .setHandleInvalid("keep")

  // Assemble features into a single vector
  private val assembler = new VectorAssembler()
    .setInputCols(Array("merchantIndex", "categoryIndex", "latitude", "longitude", "merchant_latitude", "merchant_longitude"))
    .setOutputCol("features")
    .setHandleInvalid("keep")

  // Label the data
  private val labeledData: DataFrame = data.withColumnRenamed("is_fraud", "label")

  // Set up the RandomForestClassifier
  private val rfClassifier = new RandomForestClassifier()
    .setLabelCol("label")
    .setFeaturesCol("features")
    .setPredictionCol("prediction")
    .setMaxBins(700)

  // Create a Pipeline to chain transformations and classifier
  private val pipeline = new Pipeline()
    .setStages(Array(merchantIndexer, categoryIndexer, assembler, rfClassifier))

  // Split the data into training and test sets
  private val Array(trainingData, testData) = labeledData.randomSplit(Array(0.8, 0.2), seed = 12345)

  // Train the model
  val model = pipeline.fit(trainingData)

  private val modelPath = "src/main/scala/FraudDetectionModel"
  model.write.overwrite().save(modelPath)

  // Evaluate the model on the test data
  private val predictions = model.transform(testData)
  private val evaluator = new BinaryClassificationEvaluator().setLabelCol("label")
  private val accuracy = evaluator.evaluate(predictions)
  println(s"Test set accuracy = $accuracy")
}