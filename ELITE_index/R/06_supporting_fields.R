#####################################################
#   Add/calculate fields of supporting information
#####################################################

# Returns new fields of
### - inventory year (without full date)
### - habitat classification needed in ELITE calculator (groves, moist and dry heath forests)
### - total PA area (ha)
### - PA forest area (ha) and percentage of total area (%)

# also removes empty geometries and calculates area from geometry if area field is NA

supporting_fields <- function(STANDS, BT_COMPARTMENTS) {
  
  ### year of forest inventory
  
  STANDS$inventory_year <- as.numeric(substr(STANDS$inventorytime, 1, 4)) 
  STANDS$inventorytime <- NULL # remove the original inventory time columnm
  
  ### habitat type
  
  STANDS$habitat <- case_when(STANDS$inventoryclass %in% c(241,242,251) ~ "kangas", # moist heath forests (the most common type in Finland)
                              STANDS$inventoryclass %in% c(252) ~ "lehto",          # groves/herb-rich forests
                              STANDS$inventoryclass %in% c(231,232) ~ "karukko")    # dry heath forests
  

  ### area fields
  
  #remove empty geometries
  STANDS <- STANDS[!st_is_empty(STANDS),]
  # calculate possible missing area values from geometry column
  STANDS$area_ha[STANDS$area_ha==0] <- st_area(STANDS[STANDS$area_ha==0,]) 
  
  # calculate total PA area and PA forest area and percentage and merge to STANDS
  BT_COMPARTMENTS <- st_set_geometry(BT_COMPARTMENTS, NULL)
  area_fields <- BT_COMPARTMENTS %>% 
    group_by(PA_name, PA_type) %>%
      summarise(PA_area_ha = sum(area_ha),
                PA_forest_ha = sum(area_ha[inventoryclass %in% c(231:252)])
                )
  area_fields$PA_forest_pct <- round(area_fields$PA_forest_ha/area_fields$PA_area_ha*100, 1)
  STANDS <- merge(STANDS, area_fields, by = c("PA_name", "PA_type"), all.x = TRUE)  
  
  
  return(STANDS)
}



