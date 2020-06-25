###########################################################################
#                       LARGE TRUNKS IN TREE STRATUM:
#
#                   ESTIMATE WEIBULL SIZE DISTRIBUTION (1/2)
#      AND CALCULATE NUMBER OF STEMS LARGER THAN TRESHOLD DIAMETER (2/2)
###########################################################################


##### FUNCTION 1/2: CALIBRATE WEIBULL DISTRIBUTION FUNCTION (Siipilehto 1999)

estimate_weibull <- function(x) {
  dgm <- as.numeric(x['avg_diameter']) # cm
  G <- as.numeric(x['basalarea'])        # m2
  t <- as.numeric(x['age_yr'])
  species <- as.numeric(x['species'])
  
  if (G==0 | dgm == 0) { # return zero if basal area or average tree diameter is zero
    calc_weibull <- 0
    
  } else {
    
    ### Define Weibull distribution parameters c and b (scale and shape parameters) in stratum of trees in stand
    
    ## C-parameter function depends of species (Siipilehto, 1999 - table 4)
    # (these parameter functions are calibrated with data from southern Finland and might not be perfect for other locations)
    
    if (species %in% c(10:19)) { # pine 
      c <- 0.2017*dgm + 1.5302 
    } else if (species %in% c(20:29, 70:89)) { # spruce (+ juniper and larch)
      c <- 0.1226*dgm + 1.7371 
    } else if (species %in% c(30:68, 90:96)) { # birch or other broad-leaved 
      c <- 0.08632*dgm + 0.02185*t + (-0.1126)*G + 3.7062
    } else {
      c <- 0.08632*dgm + 0.02185*t + (-0.1126)*G + 3.7062 # birch if species not recognized (code 98)
      warning(paste('species unidentified on stand:', x['SK_BTKUVID'], (". Using birch parameters")))
    }
    
    # b parameter calculated from c and average diameter
    
    b <- dgm/((-log(0.5))^(1/c))
    
    ### Calibrate Weibull distribution function of diameter (d) in tree stratum.
    calc_weibull <- function(d) {
      ((c/b)*(d/b)^(c-1))*(exp(1))^(-((d/b)^c))
    }
    
    
  }  
  
  # return calibrated function or zero if data is invalid
  
  return(calc_weibull)
}

##############################################################################################


### FUNCTION 2/2 : CALCULATE NUMBER OF STEMS THAT ARE BROADER THAN DEFINED DIAMETER TRESHOLD VALUE


calc_largestems <- function(G, treshold_cm, distribution_function) {
  
  ### if weibull zero (no function) -> number of large trunks returns zero
  
  if (is.function(distribution_function) == FALSE) {
    result <- 0
    
  } else {
  
  ### Use diameter distribution function and basal area (G) to estimate actual stem number in diameter classes
  
  diam_classes <- seq(from = 1, to = 99, by = 2) # sequence of 2cm diameter class midpoints (0cm-100cm)
  stem_nvec <- c() # number of stems per class will be stored in vector
  
  # calculate number of stems in each 2cm diameter class:
  for (d in diam_classes) {
    G_inclass <- G * integrate(distribution_function, d-1, d+1)$value # basal area in class
    n_inclass <- G_inclass/(pi*(((d/100)/2)^2)) # how many circles fits in that basal area when diameter is class midpoint
    n_inclass <- round(n_inclass, 0) # round to nearest integer
    stem_nvec <- c(stem_nvec, n_inclass) # save stem number of class in vector
  }
  
  # table of diameter classes and responding stem number
  stems_inclasses <- data.frame(diam_class = diam_classes, stems = stem_nvec)
  
  # calculate and return number of large stems from table, with diameter larger than defined treshold value (default d > 40 cm) 
  result <- sum(stems_inclasses$stems[stems_inclasses$diam > treshold_cm])
  

  }
  
return(result)
  
}
