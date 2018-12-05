#This script appends binary indicators and durations to the atus dataframe using
#the atus_functions


#Defining activity code subsets
all.trcodep <- unique(atus$trcodep) %>% sort()
rec_travel <- str_subset(all.trcodep,"1813") #"1813"
rec_indoor <- c("130101","130103","130105","130107","130109","130111","130115",
                "130117","130119","130120","130126","130128","130129","130130",
                "130132","130133","130134","130135","130136","130199","050203")
rec_outdoor <- c("130102","130104","130106","130108","130110","130110","130112",
                 "130113","130114","130116","130118","130121","130122","130123",
                 "130124","130125","130127","130131","130202","130204","130206",
                 "130208","130210","130212","130213","130214","130216","130218",
                 "130221","130222","130223","130224","130225","130227","130231")

###############################################
#Calculating binary and time spent on activity lists

atus.temp <- activity.bin.duration(atus.df = atus %>%
                                     dplyr::filter(tuwho_code %in% c(18,19,22,24)),
                                   act.code=c(rec_travel,rec_indoor,rec_outdoor),
                                   type = "both") %>%
  mutate(rec_indoor_bin=atus.col.sum(.,rec_indoor,"bin"),
         rec_indoor_dur=atus.col.sum(.,rec_indoor,"dur"),
         rec_outdoor_bin=atus.col.sum(.,rec_outdoor,"bin"),
         rec_outdoor_dur=atus.col.sum(.,rec_outdoor,"dur"),
         rec_travel_bin=atus.col.sum(.,rec_travel,"bin"),
         rec_travel_dur=atus.col.sum(.,rec_travel,"dur"))


###############################################


smokeByCaseid     <- group_by(atusShortall, tucaseid) %>% 
                     summarise_at(31:870,sum)
                    