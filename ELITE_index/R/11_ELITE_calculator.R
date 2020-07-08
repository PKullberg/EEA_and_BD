## This is a function for calculating ecosystem condition for forested areas in Finland ##
## The condition index is based on the method and parameters that are described in the "Elinympäristöjen tilan edistäminen suomessa" report (Kotiahoh et al eds. 2015, https://helda.helsinki.fi/bitstream/handle/10138/156982/SY_8_2015.pdf) ##
## Author: Peter Kullberg, peter.kullberg@ymparisto.fi

# libraries
library(dplyr)

## Create lists of reference values and weights for the three forested ecosystem groups mentioned in the Kotiaho et al (2015)
# the ecoregion names refer to: 
# kangas = Lehtomaiset, tuoreet ja kuivahkot Kangasmetsät; lehdot = lehdot; karukot = kuivat- ja karukkokankaat
# dead_wood = lahopuu (m3/ha), large_trunks = järeä puu (kpl/ha), broad_leaved = lehtipuu (m3/ha) and burnt_area = palanut ala (ha/v)

reference_variables <- list(
  kangas = c(dead_wood = 80, large_trunks = 20, broad_leaved = 50),
  lehto = c(dead_wood = 100, large_trunks = 30, broad_leaved = 100),
  karukko = c(dead_wood = 40, large_trunks = 10, burnt_area = 1) # Burnt are is just a dummy value that should not be used
)

# the original weights
feature_weights <- list(
  kangas = c(dead_wood = 0.6, large_trunks = 0.4, broad_leaved = 0.4),
  lehto = c(dead_wood = 0.4, large_trunks = 0.4, broad_leaved = 0.6),
  karukko = c(dead_wood = 0.4, large_trunks = 0.4, burnt_area = 0) # Burnt are now with weight 0 as there is no good data avaialble 
)

# weights to be used with the scaled metric
# the aim is to retain the the original interpretation of the weights
# original interpretation: "if feature is comletely missing and others at maximum the elite value should be 1 - weight (original)"
feature_weights_s <- list(
  kangas = c(dead_wood = 0.419, large_trunks = 0.279, broad_leaved = 0.279),
  lehto = c(dead_wood = 0.279, large_trunks = 0.279, broad_leaved = 0.419),
  karukko = c(dead_wood = 0.232, large_trunks = 0.232, burnt_area = 0.29)
)

# weights to be used with the linearized metric to retain the original interpretation of weight
feature_weights_l <- list(
  kangas = c(dead_wood = 0.81, large_trunks = 0.64, broad_leaved = 0.64),
  lehto = c(dead_wood = 0.64, large_trunks = 0.64, broad_leaved = 0.81),
  karukko = c(dead_wood = 0.52, large_trunks = 0.52, burnt_area = 0.62)
)

# Function for calcualting the condition index
# Inputs: 
# cur_values = the measured values in the area of interest as a named list, names must match the names in the reference variable list
# habitat = name of the habitat as given in the variable and weight lists
# reference_variable_list = named list of named vectors of reference variables
# weight_variable_list = named list of named vectors of weights for each variable
# exceed_warnings = warn if some value exceeds the reference value

# this is the original elite index, that ranges from product of 1-weghts used to 1 (although Kotiaho et al 2015 says it ranges from 0 to 1)
ELITE_value <- function(cur_values, habitat, reference_variable_list = reference_variables, weight_list = feature_weights, exceed_warnings = T) {
  
  stopifnot(habitat %in% names(reference_variable_list))
  
  # read right reference values and weights, although the original publication say 
  ref_values <- reference_variable_list[[habitat]]
  weights <- weight_list[[habitat]]
  
  # if inputs exceed reference values replace them with the reference value
  if(exceed_warnings) if(any(cur_values > ref_values)) warning("One or more input values exceeds the reference value. Replacing exceeding values with reference value.\n")
  cur_values[cur_values > ref_values] <- ref_values[cur_values > ref_values]
  
  # compute the ELITE value
  prod(1 - weights * (1 - cur_values / ref_values))
  
}

# this version scales the original elite index to strictly range from from 0 to 1
ELITE_value_scaled <- function(cur_values, habitat, reference_variable_list = reference_variables, weight_list = feature_weights_s, exceed_warnings = T) {
  
  stopifnot(habitat %in% names(reference_variable_list))
  
  # read right reference values and weights
  ref_values <- reference_variable_list[[habitat]]
  weights <- weight_list[[habitat]]
  
  # if inputs exceed reference values replace them with reference value
  if(exceed_warnings) if(any(cur_values > ref_values)) warning("One or more input values exceeds the reference value. Replacing exceeding values with reference value.\n")
  cur_values[cur_values > ref_values] <- ref_values[cur_values > ref_values]
  
  scaler <- prod(1 - weights)
  
  # compute the scaled ELITE value
  (prod(1 - weights * (1 - cur_values / ref_values)) - scaler) / (1 - scaler)
  
}

# this value linearizes (having all variables at 0.5 gives index close to 0.5) the original elite index and scales it range from 0 to 1
ELITE_value_linear <- function(cur_values, habitat, reference_variable_list = reference_variables, weight_list = feature_weights_l, exceed_warnings = T) {
  
  stopifnot(habitat %in% names(reference_variable_list))
  
  # read right reference values and weights
  ref_values <- reference_variable_list[[habitat]]
  weights <- weight_list[[habitat]]
  
  # if inputs exceed reference values replace them with reference
  if(exceed_warnings) if(any(cur_values > ref_values)) warning("One or more input values exceeds the reference value. Replacing exceeding values with reference value.\n")
  cur_values[cur_values > ref_values] <- ref_values[cur_values > ref_values]
  
  scaler <- prod(1 - weights)^(1 / length(cur_values))
  
  # compute the ELITE value
  ((prod(1 - weights * (1 - cur_values / ref_values)))^(1 / length(cur_values)) - scaler) / (1 - scaler)
}


# this just a simple wrapper that vectorizes the ELITE_value function 
ELITE_calculator <- function(cur_values, habitat, reference_variable_list = reference_variables, weight_list = feature_weights) {
  apply(cur_values, 1, function(x) ELITE_value(x, habitat = habitat, reference_variable_list = reference_variable_list, weight_list = weight_list))
}



