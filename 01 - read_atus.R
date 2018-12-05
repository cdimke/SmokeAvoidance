#####################
#Reading in Stata files leaving numerical codes

file.parts <- c("data/atus/atus","_0317.dta")
atus.act <- read.dta(str_c(file.parts[1],"act",file.parts[2]),convert.factors = F)
atus.cps <- read.dta(str_c(file.parts[1],"cps",file.parts[2]),convert.factors = F)
atus.resp <- read.dta(str_c(file.parts[1],"resp",file.parts[2]),convert.factors = F)
atus.rost <- read.dta(str_c(file.parts[1],"rost",file.parts[2]),convert.factors = F)
atus.who <- read.dta(str_c(file.parts[1],"who",file.parts[2]),convert.factors = F)


###############################
#Preliminary data cleanup: 
#table specific changes that don't radically alter the variables from original data
#drop variables that we won't use --> streamlines merge
##############################
#Activity table
#Creating useful start and stop times
act <- atus.act %>% mutate_all(na_if,y=-3) %>% mutate_all(na_if,y=-2) %>% mutate_all(na_if,y=-1) %>%
  group_by(tucaseid) %>% 
  mutate(stop=cumsum(tuactdur24),
         start=stop-tuactdur24) %>% 
  select(tucaseid, tuactivity_n, start, stop, tuactdur24, trcodep, tewhere) %>%
  ungroup() %>% 
  as_tibble()

save(act,file = "cache/act.Rdata")

#########
#CPS table
cps <- atus.cps %>% mutate_all(na_if,y=-3) %>% mutate_all(na_if,y=-2) %>% mutate_all(na_if,y=-1) %>% 
  mutate(hhinc=coalesce(hefaminc,hufaminc),
         metro=if_else(coalesce(gemetsta,gtmetsta)==1,1,0)) %>%
  select(tucaseid,tulineno,gestfips,gtcbsa,gtco,hhinc,ptdtrace,pehspnon,peeduca,pemlr) %>%
  as_tibble()

save(cps,file = "cache/cps.Rdata")

#########
#Respondent table
#creating useful date variables
resp <- atus.resp %>% mutate_all(na_if,y=-3) %>% mutate_all(na_if,y=-2) %>% mutate_all(na_if,y=-1) %>%
  mutate(date.temp=ymd(tudiarydate),
         year=year(date.temp),
         month=month(date.temp),
         day=day(date.temp),
         dow=wday(date.temp)) %>% 
  select(tucaseid,tulineno,year,month,day,dow,trholiday,telfs,trdtind1,trdtocc1,trernwa,tufnwgtp) %>%
  as_tibble()

save(resp,file = "cache/resp.Rdata")

#########
#Roster file
rost <- atus.rost %>% mutate_all(na_if,y=-3) %>% mutate_all(na_if,y=-2) %>% mutate_all(na_if,y=-1) %>% 
  as_tibble()

save(rost,file = "cache/rost.Rdata")

#########
#Who table
#setting entries where who was not asked as own person (usually bathroom)
who <- atus.who %>% mutate_all(na_if,y=-3) %>% mutate_all(na_if,y=-2) %>% mutate_all(na_if,y=-1) %>% 
  mutate(tuwho_code=ifelse(is.na(tuwho_code) & trwhona==1,18,tuwho_code)) %>% 
  as_tibble()

save(who,file = "cache/who.Rdata")

##############
#clean up workspace
rm(list=objects(pattern = "atus"))
