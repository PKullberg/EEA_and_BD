###############################################################
#                READ IN BIOTOPE COMPARTMENT DATA 
#       AND RETURN DEFINED SUBSET WITH NECESSARY COLUMNS 
###############################################################



read_compartmentdata <- function (PA_sites) {

  print(paste("Started at ", substring(Sys.time(), 12, 19)))

  path <- paste(getwd(), BTKUV_file, sep="/")
  
  # read in shapefile
  BT_COMPARTMENTS <- st_read(path)
  

  # first create subsets of all PA types
  BT_COMPARTMENTS_NATU <- BT_COMPARTMENTS[!is.na(BT_COMPARTMENTS[,cols_natura[2]])[,1], # select rows that possess site name
                                          c(cols_natura, cols_BTKUV)]                   # select columns ("R/define_column_and_filenames.R)
  BT_COMPARTMENTS_VSA <- BT_COMPARTMENTS[!is.na(BT_COMPARTMENTS[,cols_vsa[2]])[,1], 
                                         c(cols_vsa, cols_BTKUV)] 
  BT_COMPARTMENTS_YSA <- BT_COMPARTMENTS[!is.na(BT_COMPARTMENTS[,cols_ysa[2]])[,1], 
                                         c(cols_ysa, cols_BTKUV)] 
  BT_COMPARTMENTS_VMS <- BT_COMPARTMENTS[!is.na(BT_COMPARTMENTS[,cols_vms[2]])[,1], 
                                          c(cols_vms, cols_BTKUV)] 

  # rename columns from Finnish to English
  colnames_english <- c("PA_id", "PA_name", "stand_id", "inventoryclass", "forvegetation_zone", "area_ha", "inventorytime", "geometry")
  names(BT_COMPARTMENTS_VMS) <- names(BT_COMPARTMENTS_YSA) <- names(BT_COMPARTMENTS_VSA) <-  names(BT_COMPARTMENTS_NATU) <- colnames_english

  # store PA type
  BT_COMPARTMENTS_NATU$PA_type <- "NATURA"
  BT_COMPARTMENTS_VSA$PA_type <- "VSA"
  BT_COMPARTMENTS_YSA$PA_type <- "YSA"
  BT_COMPARTMENTS_VMS$PA_type <- "VMS"

  # combine subsets together
  BT_COMPARTMENTS <- rbind(BT_COMPARTMENTS_NATU, BT_COMPARTMENTS_VSA, BT_COMPARTMENTS_YSA, BT_COMPARTMENTS_VMS)

  # Return biotope compartments in sites defined by parameter "PA_sites":
  
  ### All sites
  if("All" %in% PA_sites) {
    BT_COMPARTMENTS <- BT_COMPARTMENTS
  }

  ### Or from defined types of sites 
  else if ("NATURA" %in% PA_sites | "VSA" %in% PA_sites | "YSA" %in% PA_sites | "VMS" %in% PA_sites) {
    BT_COMPARTMENTS <- subset(BT_COMPARTMENTS, subset= BT_COMPARTMENTS$PA_type %in% PA_sites)
  }
  
  ### Or only from named PA's 
  else {
    BT_COMPARTMENTS <- subset(BT_COMPARTMENTS, subset= BT_COMPARTMENTS$PA_name %in% PA_sites)
  }

  return(BT_COMPARTMENTS)
}
  

