package com.melvin

import com.maxmind.geoip2.DatabaseReader
import com.maxmind.geoip2.model.CityResponse
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.expressions.UserDefinedFunction
import org.apache.spark.sql.functions._

import java.io.File
import java.net.InetAddress

object GeolocationEnrichment {
  def enrichWithGeolocation(df: DataFrame): DataFrame = {
    // Your implementation for geolocation enrichment
    // Path to the GeoLite2 database
    val geoDbPath = "/app/GeoLite2-City.mmdb"
    // Initialize the database reader
    val dbReader = new DatabaseReader.Builder(new File(geoDbPath)).build()
    // UDF to retrieve geolocation data
    val geolocationUDF: UserDefinedFunction = udf((ip: String) => {
      try {
        // Parse IP address
        val inetAddress = InetAddress.getByName(ip)
        val response: CityResponse = dbReader.city(inetAddress)

        // Extract geolocation data
        Map(
          "country" -> Option(response.getCountry.getName).getOrElse("Unknown"),
          "city" -> Option(response.getCity.getName).getOrElse("Unknown"),
          "latitude" -> Option(response.getLocation.getLatitude).getOrElse(0.0),
          "longitude" -> Option(response.getLocation.getLongitude).getOrElse(0.0)
        )
      } catch {
        case _: Exception =>
          Map("country" -> "Unknown", "city" -> "Unknown", "latitude" -> 0.0, "longitude" -> 0.0)
      }
    })
    val geoEnrichedDF = df.withColumn("geolocation", geolocationUDF(col("ip_address")))
    geoEnrichedDF
  }
}
