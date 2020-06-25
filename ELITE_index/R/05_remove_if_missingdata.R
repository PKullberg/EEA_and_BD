########################################################
#   Remove stands that miss subgroup data or area (1/2)
#   Remove unnecessary strata that miss related stand (2/2)
########################################################

### function 1/2

remove_stand_if_missingdata <- function(STANDS, LIVING_TREES, DEADWOOD) {
  
  # remove stands where area still is 0 or NA
  STANDS <- subset(STANDS, area_ha > 0 & !(is.na(STANDS$area_ha))) 
  
  # remove stands which miss related LIVING_TREE table
  STANDS <- STANDS[STANDS$stand_id %in% LIVING_TREES$stand_id, ]
  
  # remove stands which miss related DEADWOOD table
  STANDS <- STANDS[STANDS$stand_id %in% DEADWOOD$stand_id, ] 
  
  # ###
  # # store information of how much area is lost due to missing data
  # df <- data.frame(PA_name = STANDS$PA_name, final_area = STANDS$area_ha) # temporary dataframe for calculation
  # STANDS <- merge(STANDS, (df %>% group_by(PA_name) %>%  
  #                            summarise(missing_data_ha = forest_area_ha[1] - sum(final_area))))
  # 
  # 
  return(STANDS)
}

### function 2/2

remove_stratum_if_missingdata <- function(STRATUM_TABLE, STANDS) {
  
  # remove stratum row if stand id not found in STANDS
  STRATUM_TABLE <- STRATUM_TABLE[STRATUM_TABLE$stand_id %in% STANDS$stand_id, ]
  
  return(STRATUM_TABLE)
}
