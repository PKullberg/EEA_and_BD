####################################################################
#        Calculate amount of deadwood (m3) in each stand
####################################################################

calc_deadwood <- function(DEADWOOD) {
  
  # Summarise volume of all subgroups of deadwood types in stand
  
  deadwood_df <- DEADWOOD %>%
    group_by(stand_id) %>%
    summarise(dead_wood = sum(volume_m3), 
              
              # Additionally calculate volume in each decayclass (from recently died (1) to soft (3))
              # There are versions of elite calculator where distibution in classes is taken into account, though not the version in this script
              decayclass_1_m3 = sum(volume_m3 * decayclass_1/100), 
              decayclass_2_m3 = sum(volume_m3 * decayclass_2/100), 
              decayclass_3_m3 = sum(volume_m3 * decayclass_3/100)) 
  
}

