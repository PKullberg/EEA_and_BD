####################################################################
#        Calculate number of large trunks in each stand
####################################################################


calc_largetrunks <- function(LIVING_TREES) {
  
  print("Calculating large trunks")
  print(paste("Started at: ", substring(Sys.time(), 12, 19), " (approximate processing time: ", round(nrow(LIVING_TREES)/661/60,1), "min)"))
  
  # Large trunk = tree diameter at breast height more than 40cm 
  
  treshold_cm <- 40
  
  # calculate number of large trunks in each subgroup of stand
  # (requires estimating species specific diameter distribution from mean values (Siipilehto 1999). See function "R/06_2_estimate_weibull_and_calc_largestems.R") 
  
  LIVING_TREES$large_trunks <- apply(LIVING_TREES, 1, function(row) { 
    G <- as.numeric(row['basalarea']) # m2
    calc_largestems(G, treshold_cm, estimate_weibull(row))} 
  )
  
  # estimate_weibull() -> site specific size distribution function
  # calc_largestems() -> calculate estimated stem number from diameter distribution function and basal area of site. Return number of stems over large trunk treshold diameter.
  
  # calculate number of large trunks in each stand by summarizing subgroup large stem numbers
  largetrunks_df <- LIVING_TREES %>%
    group_by(stand_id) %>%
    summarise(large_trunks  = sum(large_trunks))
  
  
}
