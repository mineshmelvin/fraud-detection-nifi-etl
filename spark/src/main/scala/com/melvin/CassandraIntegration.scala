package com.melvin

//package com.melvin
//
//import org.apache.spark.sql.DataFrame
//
//object CassandraIntegration {
//  def writeToCassandra(df: DataFrame, keyspace: String, table: String): Unit = {
//    df
//      .writeStream
//      .foreachBatch{ (batchDF, _) =>
//        batchDF.write
//          .format("org.apache.spark.sql.cassandra")
//          .options(Map("keyspace" -> keyspace, "table" -> table))
//          .mode("append")
//          .save()
//      }
//      .outputMode("update")
//      .start()
//  }
//}
