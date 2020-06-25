###################################################################
#                                                                 #
#                         FULL PROCESS OF                         #
#         CALCULATING ELITE ECOSYSTEM CONDITION INDICES           #
#             FROM PROTECTED AREA FOREST STAND DATA               #
#                                                                 #
###################################################################

# This script uses forest stand data from Finnish protected areas (PAs) to calculate 
# stand specific ecosystem condition indices (ELITE), and provide PA specific ELITE 
# metrics of forest quality (PA mean ELITE, amount of good quality patches).

# ELITE method used here describes the current condition of habitat compared to its natural state, in respect 
# to three indicator variables: amount of deadwood, broad-leaved trees and large trunks. For detailed information of method, see report
# of Kotiaho et al. (2015) https://helda.helsinki.fi/handle/10138/156982,
# or function in "R/10_ELITE_calculator.R" script file.

# INPUT DATA: Biotope compartment data of Finnish protected areas (Suojelualueiden biotooppikuviot), a database managed by Metsähallitus (not openly available)
                # biotope compartments shapefile (SK_BTKUV.shp) = stands
                # related treestratum database files (SK_PUUELAVO.dbf, SK_PUULAHO.dbf)

            # In case input data field names differ from those in this script, update changes in "R/02_define_columnnames"

# OUTPUT: # geospatial or csv file(s): 
          # stand specific ELITE indices / PA specific ELITE metrics and supporting fields (see "output_fields.txt")


# Running the process for all types of all Finnish protected areas takes ~ 1 hour 17mins   
# (which is 1 504 815 compartments of which 268 786 are calculable forest stands)



# # # # #  SPECIFY FOLLOWING PARAMETERS USED IN THE SCRIPT # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#           (THIS IS THE ONLY PART THAT HAS TO BE MODIFIED)
# 
#
# Set working directory to project root folder that contains the "R" folder and "plan.R":
setwd("C:/ELITE_workflow")
#
#### INPUT FILES ####
#
BTKUV_file <- "Data/SK_BTKUV.shp" # biotope data including forest stands (.shp)
PUUELAVO_file <- "Data/SK_PUUELAVO.dbf" # tree stratum data of living trees (.dbf)
PUULAHO_file <- "Data/SK_PUULAHO.dbf" # tree stratum data of deadwood (.dbf)
#
#
### PROCESSING OPTIONS ###
#
# specify PA sites to which ELITE will be calculated
PA_sites <- c("All") 

# c("All") - All types of PA's
# c("NATURA") - All NATURA areas
# c("VSA") - All national arotected areas (Valtion luonnonuojelualueet)
# c("YSA") - All private protected areas 
# c("VMS") - All state owned areas for other protective uses (valtion muut suojelutarkoituksiin varatut alueet)
# c("NATURA", "VSA") - Multiple types of PA's
#
# ELITE index treshold value(s) defining "quality forest patch" (0-1)
quality_treshold <- c(0.3, 0.5)
#
#
#### OUTPUT OPTIONS ####
#
# Set (existing) folder for output:
writeout_folder <- "write_out"
# Set output format ("geospatial"/"csv"/"both). Feature centroid coordinates are calculated in field if not geospatial.
writeout_format <- "both"
# Specify file format if output will be geospatial file ("GPKG", "ESRI Shapefile", etc.):
driver <- "GPKG"
#
# Output ELITE data: ("stand"/"PA"/"both")
output_level <- "both"
#
# 
# Before running the code make sure that filenames and field names of input data match those defined 
# in "R/02_define_column_and_filenames" and update the script if necessary.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



###########################################
# Run files in R-folder:
# - call libraries (and install them if not yet installed)
# - set options
# - define file and field names of input data
# - bring functions used in the script

# Note! Run again if functions are modified to apply changes!
sapply(list.files(path="R/", full.names=TRUE), source)
###########################################


###########################################
#         READ IN AND PREPARE DATA        #
###########################################

# Read in biotope compartment data from specified areas. 
# Stores and renames necessary columns. Combine PA names from multiple fields in one field and store PA type.
BT_COMPARTMENTS <- read_compartmentdata(PA_sites) 

# subset to compartments classified as forests and calculate forest percentage of full PA area
STANDS <- subset_to_forests(BT_COMPARTMENTS)

# read in related tree stratum tables of living tree and deadwood attributes from stands
LIVING_TREES <- read_treestratum_tables("living", STANDS$stand_id)
DEADWOOD <-  read_treestratum_tables("dead", STANDS$stand_id)

# add new fields: elite habitat type, inventory year, PA total area and PA forest area (ha and percentage)
STANDS <- supporting_fields(STANDS, BT_COMPARTMENTS)

# Remove stands that miss tree stratum data or area. 
# Remove unnecessary strata.
STANDS <- remove_stand_if_missingdata(STANDS, LIVING_TREES, DEADWOOD)
LIVING_TREES <- remove_stratum_if_missingdata(LIVING_TREES, STANDS)
DEADWOOD <- remove_stratum_if_missingdata(DEADWOOD, STANDS)


#########################################
#    CALCULATE ELITE INPUT VARIABLES    
#########################################

stand_largetrunks_df <- calc_largetrunks(LIVING_TREES) # may take a while - about 15s /10 000 rows
stand_broadleaved_df <- calc_broadleaved(LIVING_TREES)
stand_deadwood_df    <- calc_deadwood(DEADWOOD)


# merge calculated variables to STAND data
STANDS <- merge(STANDS, stand_largetrunks_df, by = 'stand_id', all.x = TRUE)
STANDS <- merge(STANDS, stand_broadleaved_df, by = 'stand_id', all.x = TRUE)
STANDS <- merge(STANDS, stand_deadwood_df, by = 'stand_id', all.x = TRUE)


# change absolute values of large trunks, broadleaved trees and deadwood to amount per hectare
STANDS <- inputvalues_per_ha(STANDS)



##############################################
#        CALCULATE STAND ELITE INDICES       
#  AND ELITE ATTRIBUTES FOR PROTECTED AREAS  
##############################################

# see script "R/ELITE_calculator.R" and report of Kotiaho et al. (2015) for method description


# STANDS

STANDS$elite <- apply(STANDS, 1, function(row) {
  
  ELITE_value(cur_values = c(dead_wood = row[['dead_wood']], 
                             large_trunks = row[['large_trunks']], 
                             broad_leaved = row[['broad_leaved']]), 
              habitat = row[['habitat']])
  
  # Gives warning if input values exceed natural forest reference values. This happens often especially in case of volumes of broadleaved trees.
  # In this case, the function lowers the input value to reference value (Elite-index maximum is 1, or 100%)
})

# PROTECTED AREAS

PA_ELITE <- calc_ELITE_PA_metrics(STANDS, quality_treshold)



#################################################
#            write out as specified:
#################################################

write_out(PA_ELITE, STANDS, output_level, writeout_format, writeout_folder)




