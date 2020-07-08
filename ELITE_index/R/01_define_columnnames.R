#############################################
#     DEFINE COLUMNNAMES OF INPUT DATA
#############################################


# biotope compartment data (SK_BTKUV) column names (As default as in SAKTI 2020)

cols_BTKUV <- c("SK_BTKUVID", # biotope compartment/stand id (biotooppikuvion id)
                "INVENTOINT", # "inventory class" code (inventointiluokka)
                "MKVYOHYKE",  # forest vegetation zone (metsäkasvillisuusvyöhyke)
                "PINTA_ALA",  # biotope compartment area (ha) (biotooppikuvion pinta ala hehtaareina) 
                "PUUSTOAR_1", # time of biotope compartment inventory
                "geometry")   # biotope compartment polygon geometry

# site name and id columnnames in SK_BTKUV

cols_natura <- c("SMV_NATURA", # Natura site id
                 "SMV_NATU_1") # Natura site name
cols_vsa <- c("SMV_VSA_ID",    # VSA site id
              "SMV_VSA_NI")    # VSA site name
cols_ysa <- c("SMV_YSA_AL",    # YSA site id
              "SMV_YSA__1")    # YSA site name
cols_vms <- c("SMV_VMS_ID",    # VMS site id
              "SMV_VMS_NI")    # VMS site name

# Columnnames in tree stratum files

# living trees
cols_PUUELAVO <- c("SK_BTKUVID", # biotope compartment/stand id (biotooppikuvion id) - links table to BTKUV compartment file!
                   "PUULAJI",    # tree species code
                   "M_IKA",      # age (years)
                   "M_KESKILAP", # mean diameter (cm)
                   "M_KESKIPIT", # mean height
                   "M_PPA",      # basal area (m2)
                   "M_RUNKOLUK", # stem number (not needed in process)
                   "M_TILAVUUS", # volume (m3)
                   "JAKSO",      # storey (defines treestratum together with species)
                   "OSITE_NO")   # treestratum number in stand

# deadwood
cols_PUULAHO <- c("SK_BTKUVID", # biotope compartment/stand id (biotooppikuvion id) - links table to BTKUV compartment file!
                  "TILAVUUS",   # volume (m3)
                  "LAHOASTE_I", # decayclass 1 (hardest)
                  "LAHOASTE_1", # decayclass 2
                  "LAHOASTE_2") # decayclass 3 (softest)
