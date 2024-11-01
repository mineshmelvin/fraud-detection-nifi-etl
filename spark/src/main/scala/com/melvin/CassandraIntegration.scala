package com.melvin

import org.apache.spark.sql.DataFrame

object CassandraIntegration {
  def writeToCassandra(df: DataFrame, keyspace: String, table: String): Unit = {
    df
      .writeStream
      .foreachBatch{ (batchDF: org.apache.spark.sql.Dataset[org.apache.spark.sql.Row], batchId: Long) =>
        batchDF.write
          .format("org.apache.spark.sql.cassandra")
          .options(Map("keyspace" -> keyspace, "table" -> table))
          .mode("append")
          .save()
      }
      .outputMode("update")
      .start()
  }
}