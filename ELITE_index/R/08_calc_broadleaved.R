####################################################################
#   Calculate amount of broad-leaved trees (m3) in each stand
####################################################################

calc_broadleaved <- function(LIVING_TREES) {
  
  # species codes of broadleaved trees in SAKTI
  broadl_codes <- c(30:68, 90:96) 
  
  # for detailed information of classification, see file  " BT-kuviot_koodistot_SYKE.xlsx " -> PUULAJI
  
  
  # group by stand ->  sum volume of broadleaved subgroups in each stand
  
  broadleaved_df <- LIVING_TREES %>% group_by(stand_id) %>%
    summarise(broad_leaved = sum(volume_m3[species %in% broadl_codes])) # in this elite calculator amount of broadleaved trees as m3/ha
              #broadleaved = sum(volume_m3[species %in% broadl_codes])/sum(volume_m3)*100) # alternatively calculate percentage of broadleaved trees of all trees
  
  
}