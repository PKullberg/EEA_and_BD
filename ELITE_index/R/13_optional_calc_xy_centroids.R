####################################
#       CALCULATE XY-CENTROIDS
####################################

calc_xy_centroids <- function(object) {
  
  object<- st_centroid(object)
  
  object$centroid_lat <- apply(object, 1, function(x){st_coordinates(x$geometry)[,'Y']})
  object$centroid_lon <- apply(object, 1, function(x){st_coordinates(x$geometry)[,'X']})
  
  object <- st_set_geometry(object, NULL)
  
  return(object)
}

# There will be warning messages "st_centroid assumes attributes are constant over geometries of x"
# No actions needed