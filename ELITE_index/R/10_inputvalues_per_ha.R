###########################################################
#     Convert absolute values of elite input variables    #
#                  to values per hectare                  #
###########################################################



inputvalues_per_ha <- function(STANDS) {
  
  STANDS$large_trunks <- STANDS$large_trunks/STANDS$area_ha
  STANDS$broad_leaved <- STANDS$broad_leaved/STANDS$area_ha
  STANDS$dead_wood <- STANDS$dead_wood/STANDS$area_ha
  
  # same for elite version where decayclasses are applied instead of deadwood as a whole:
  
  # STANDS$decayclass_1_m3 <- STANDS$decayclass_1_m3/STANDS$area_ha
  # STANDS$decayclass_2_m3 <- STANDS$decayclass_2_m3/STANDS$area_ha
  # STANDS$decayclass_3_m3 <- STANDS$decayclass_3_m3/STANDS$area_ha
  
  return(STANDS)
}

