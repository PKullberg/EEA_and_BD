write_out <- function (PA_ELITE, STANDS, output_level, writeout_format, writeout_folder) {
  
  # as geospatial file
  
  if (writeout_format == "geospatial" | writeout_format == "both") {
    
    if(output_level == "PA" | output_level == "both") {
      filename <- case_when(driver=="GPKG" ~ "PA_ELITE.gpkg", driver=="ESRI shapefile" ~ "PA_ELITE.shp")
      st_write(PA_ELITE, dsn =paste(getwd(), writeout_folder, filename, sep = "/"), driver= driver, append=FALSE)
    }
    if(output_level == "stand" | output_level == "both") {
      filename <- case_when(driver=="GPKG" ~ "STANDS_ELITE.gpkg", driver=="ESRI shapefile" ~ "STANDS_ELITE.shp")
      st_write(STANDS, dsn = paste(getwd(), writeout_folder, filename, sep = "/"), driver= driver ,append=FALSE)
    }
  }
  
  # as csv without geometry (but with feature centroid xy column)
  
  # first calculate STAND and/or PA centroid coordinates in columns and remove geometry
  if ((writeout_format == "csv" | writeout_format == "both") & (output_level=="stand" | output_level=="both")) {STANDS <- calc_xy_centroids(STANDS)}
  if ((writeout_format == "csv" | writeout_format == "both") & (output_level=="PA" | output_level=="both")) {PA_ELITE <- calc_xy_centroids(PA_ELITE)}
  
  # then write out
  if (writeout_format == "csv" | writeout_format == "both") {
    if(output_level == "PA" | output_level == "both") {
      write.csv(PA_ELITE, file = paste(getwd(), writeout_folder, "PA_ELITE.csv", sep = "/"))
    }
    if(output_level == "stand" | output_level == "both") {
      write.csv(STANDS, file = paste(getwd(), writeout_folder, "STANDS_ELITE.csv", sep = "/"))
    }
  }
  
  
}
