# Call libraries that are used in script 
# and Installs if the libraries are not yet installed.

tryCatch(library(sf), error=function(cond){message(cond)
                            install.packages('sf')
                            library(sf)})
tryCatch(library(foreign), error=function(cond){message(cond)
                            install.packages('foreign')
                            library(foreign)})
tryCatch(library(dplyr), error=function(cond){message(cond)
                            install.packages('dplyr')
                            library(dplyr)})

options(stringsAsFactors = FALSE)