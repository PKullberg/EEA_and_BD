####################################################
#         Calculate Protected area specific       #
#                   ELITE metrics                  #
#            based on stand elite-indices          #
####################################################



calc_ELITE_PA_metrics <- function(STANDS, quality_treshold) {
  
  print(paste("Started at ", substring(Sys.time(), 12, 19)))
  print(paste("Approximated processing time: ", round(nrow(STANDS)/9600,1), "min"))
  
  PA_ELITE <- STANDS %>%
    group_by(PA_name, PA_type) %>%
    summarise(PA_id = PA_id[1],
              
              elite_mean = round(weighted.mean(x=elite, w=area_ha),3), # Area weighted mean ELITE index of PA
              elite_Quality_ha = round(sum(area_ha[elite >= quality_treshold[1]]), 2),   # Absolute amount (ha) of "quality forest" in PA. ELITE quality treshold defined in main script
              elite_Quality_pct = round(100* sum(area_ha[elite >= quality_treshold[1]]) / PA_forest_ha[1], 2), # Relative amount of quality forest. Percentage of full forest area.
              elite_var = round(var(elite), 3), # variance of ELITE in PA stands
              # elite_of_top20 = weighted.mean(x=elite[elite >= quantile(elite, probs=0.8)], w=area_ha[elite >= quantile(elite, probs=0.8)]), # Area weighted mean ELITE of best 20% of stands. 
              # elite_of_top10 = weighted.mean(x=elite[elite >= quantile(elite, probs=0.9)], w=area_ha[elite >= quantile(elite, probs=0.9)]), # of best 10%
              
              inventory_year = median(inventory_year),
              forvegetation_zone = median(as.numeric(as.character(forvegetation_zone))), # assumed here that PA's hit only one zone
              
              PA_area_ha = round(PA_area_ha[1],2), # total PA area. (Calculated earlier, each stand having same value -> taking the first[1])
              PA_forest_ha = round(PA_forest_ha[1], 2), 
              PA_forest_pct = round(PA_forest_pct[1], 2), # forest area percentage of total area %
              PA_elite_forest_coverage = round(sum(area_ha)/PA_forest_ha[1]*100, 1), # % of forest area where it was possible to calculate elite index (no missing stratum or other data)
              
              lehto_pct = round(sum(area_ha[habitat== "lehto"])/sum(area_ha) *100, 1), # habitat percentages of PA forest elite area (only forest stands that do not have missing stratum data) 
              kangas_pct = round(sum(area_ha[habitat== "kangas"])/sum(area_ha) *100, 1),
              karukko_pct = round(sum(area_ha[habitat== "karukko"])/sum(area_ha) *100, 1),
              
              median_deadwood_m3 = round(median(dead_wood), 0),  # median values of elite input variables in PA
              median_broadleaved_m3 = round(median(broad_leaved),0),
              median_largetrunks_per_ha = round(median(large_trunks), 0)
              )
  
  
  # rename PA quality patch variables by quality treshold
  treshold_chr <- c(as.character(quality_treshold*100))
  names(PA_ELITE)[names(PA_ELITE) == "elite_Quality_ha"] <- paste("elite_Quality", treshold_chr[1], "_ha", sep="") 
  names(PA_ELITE)[names(PA_ELITE) == "elite_Quality_pct"] <- paste("elite_Quality", treshold_chr[1], "_pct", sep="")
  
  
  #####
  
  
  # if there are more than one quality treshold defined, calculate rest of the quality attributes and merge to data:

  
  if (length(quality_treshold) >1) {
    
    for (i in 2:length(quality_treshold)) {
      
      Q <- STANDS %>%
        group_by(PA_name, PA_type) %>%
        summarise(elite_Quality_ha = round(sum(area_ha[elite >= quality_treshold[i]], na.rm=T),2),
                  elite_Quality_pct = round(sum(area_ha[elite >= quality_treshold[i]]) / sum(area_ha),2))
      
      # rename quality variable
      names(Q)[names(Q) == "elite_Quality_ha"] <- paste("elite_Quality", treshold_chr[i], "_ha", sep="") 
      names(Q)[names(Q) == "elite_Quality_pct"] <- paste("elite_Quality", treshold_chr[i], "_pct", sep="")
      
      # remove geometry
      Q <- st_set_geometry(Q, NULL)
      Q <- ungroup(Q)
      
      # merge back
      PA_ELITE <- merge(PA_ELITE, Q, by = c("PA_name", "PA_type"), all.x = TRUE)
      
    }
  }
  
  return(PA_ELITE)
}




