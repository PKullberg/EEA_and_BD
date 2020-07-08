
# subset to compartments classified as forests (and calculate forest percentage of full PA area?)

subset_to_forests <- function(BT_COMPARTMENTS) {
  
  STANDS <- subset(BT_COMPARTMENTS, subset = BT_COMPARTMENTS$inventoryclass %in% c(231:252))

  return(STANDS)
}

# inventoryclasses for forests, codes 231:252
# for detailed information of classification, see file
#                 " BT-kuviot_koodistot_SYKE.xlsx "