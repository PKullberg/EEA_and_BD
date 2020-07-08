######################################################################

#         READ IN TREE STRATUM DATA OF LIVING TREES / DEADWOOD 

######################################################################


## Read in tree stratum tables of living trees and deadwood related to stands
## Store and rename necessary columns 
## Subset to the stands that are used in analysis


read_treestratum_tables <- function(livingtrees_or_deadwood, stands) {
  source("R/02_define_columnnames.R")
  if (livingtrees_or_deadwood == "living") {
    
    # read in dbf
    TABLE <- read.dbf(paste(getwd(),PUUELAVO_file, sep="/"), as.is = T) # (as.is=T -> does not convert character vectors to factors)
    
    # select and rename columns
    TABLE <- TABLE[,cols_PUUELAVO] # columns defined in "R/define_column_and_filenames"
    names(TABLE) <- c("stand_id", "species", "age_yr", "avg_diameter", "avg_height", 
                      "basalarea", "stemnumber", "volume_m3","storey", "treestratum_nr")
  } 
  
  if (livingtrees_or_deadwood == "dead") {
    
    # read in dbf
    TABLE <- read.dbf(paste(getwd(), PUULAHO_file, sep="/"), as.is = T)
    
    # select and rename columns
    TABLE <- TABLE[,cols_PUULAHO] # columns defined in "R/define_column_and_filenames"
    names(TABLE) <- c("stand_id", "volume_m3", "decayclass_1", "decayclass_2", "decayclass_3")
  }
  
  
  
  # subset to stands of interest
  TABLE <- subset(TABLE, stand_id %in% stands)
  
  # return either deadwood or living trees table
  return(TABLE)
}


