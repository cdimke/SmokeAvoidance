library(tidyverse)
sort.where <- 
  function(atus.df,where.code, type="both"){
        
        where.code   <- where.code %>% sort()
        
        atusWhere <- atus
        
        atusWhere <- if(type =="both" | type == "bin"){mutate(atusWhere, bin_match= 
                                                                    ifelse( tewhere %in% where.code,1,0))}
        
        atusWhere <- if(type== "both" | type == "dur"){mutate(atusWhere, dur_match= 
                                                                    ifelse(tewhere %in% where.code,atus$tuactdur24,0))}
      
      
      atusWhere <-if(type == "both" | type == "bin"){filter(atusWhere, bin_match == 1)}else 
        {filter(atusWhere,dur_match !=0)} 
      atusWhere <-atusWhere %>% group_by(tucaseid) %>%
        summarise(count=n(), actdur=sum(dur_match), teage=mean(teage), terrp=mean(terrp), tesex= mean(tesex), 
                  gestfips=mean(gestfips), gtcbsa=mean(gtcbsa), gtco=mean(gtco), hhinc=mean(hhinc), 
                  ptdtrace =mean(ptdtrace), pehspnon=mean(pehspnon),peeduca=mean(peeduca), 
                  year=mean(year),month=mean(month),day=mean(day), dow=mean(dow), trholiday=mean(trholiday),
                  telfs=mean(telfs), trdtocc1=mean(trdtocc1), tufnwgtp=mean(tufnwgtp),trdtocc1=mean(trdtocc1),
                  trernwa=mean(trernwa), pemir=mean(pemlr))
      
      return(atusWhere)
  }

