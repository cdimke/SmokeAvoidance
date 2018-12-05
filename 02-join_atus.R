#Joining data

###############################
#Joining all information on individual respondents and family
##############################
atus.ind <- left_join(left_join(rost,
                                cps, 
                                by = c("tucaseid", "tulineno")) ,
                      resp, 
                      by = c("tucaseid", "tulineno")) %>% 
  arrange(tucaseid,tulineno) %>%
  fill(year,month,day,dow,trholiday,gtcbsa,gtco,hhinc)

###############################
#Joining activity level data
##############################
atus.act <- inner_join(who,
                       act,
                       by = c("tucaseid","tuactivity_n")) %>% 
  arrange(tucaseid,tuactivity_n, tulineno) %>%
  mutate(tulineno=ifelse(trwhona==1,1,tulineno),
         tewhere=ifelse(is.na(tewhere) & between(trcodep,10000,20000),1,tewhere),
         trcodep=str_pad(trcodep,6,"left","0"))

#When the respondent does an activity with others, the record for the respondent is omitted.  It is easier to add it back.
atus.act <- bind_rows(atus.act,
                      atus.act %>% 
                        group_by(tucaseid,tuactivity_n) %>% 
                        summarize_all(funs(first)) %>% 
                        dplyr::filter(tulineno!=1 | is.na(tulineno)) %>% 
                        mutate(tulineno=1,
                               tuwho_code=18) %>%
                        ungroup()) %>%
  arrange(tucaseid,tuactivity_n,tulineno) %>%
  select(-trwhona)


################################
#Joining individual and diary data
################################
atus <- left_join(atus.act,
                  atus.ind,
                  by=c("tucaseid", "tulineno"))


###############################
#Cache ATUS compiled dataset
save(atus,file = "cache/atus.Rdata")

#clear cache of intermediate files
file.remove(str_c("cache/",c("act","cps","resp","rost","who"),".Rdata"))
