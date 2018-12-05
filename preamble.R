#This is the preamble script for the Fire Weather project.  
#It should be run once each time a user begins a new R session to work on the project.

########################
#Loading and installing packages
pacs <- c("tidyverse","lubridate","foreign","mice",
          "sf","USAboundaries","viridis","scales")
#lapply(pacs, require, character.only = TRUE)
check <- lapply(pacs, require, character.only = TRUE)
#Install if not in default library
for(pac in pacs[!unlist(check)]){
  install.packages(pac)
}


#########################
#Load helper functions
source("/Users/christinedimke/Documents/Smoke_Avoidance/munge/atus_functions.R")

#################
#Load cached data if exists otherwise build data
cache.files <- dir("cache",pattern = ".Rdata") 
if(!is_empty(cache.files)){
  for(cache in cache.files){
    message(str_c("Loading ",cache," from cache..."))
    load(str_c("cache/",cache))
  }
  message("To rebuild data from scratch, empty cache folder.")
} else {
  for(munge in dir("munge",pattern = ".R")){
    message(str_c("Running ",str_c("munge/",munge),"... "))
    source(str_c("munge",munge))
  }
}


