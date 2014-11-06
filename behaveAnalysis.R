library(reshape2)
library(plyr)
library(ggplot2)
#library(pracma)
 
df    <-read.table('txt/tests.txt',header=T,sep=" ")
df.RT <- ddply(df,.(subj,type,run,congr,correct),
                 function(x) { 
                    c(RT=mean(x$RT[is.finite(x$RT)]),
                      count=length(x$RT) )
         }) 

df.bytype <- reshape(df.RT[,-3],idvar=c('subj','congr','correct'),timevar='type',direction='wide')

df.bytype$RTdiff = df.bytype$RT.neutral    - df.bytype$RT.reward

# congr correct/incorrect RT  differences
rtdiff <- subset(ddply(df.bytype, .(subj, congr, correct),function(x){mean(x$RTdiff[is.finite(x$RTdiff)])}), congr==1&correct>-1)

write.csv(df.bytype,file='txt/typediff.csv',row.names=F)

# performance differences
cong <- df.bytype[df.bytype$congr==1,]
cong$countdiff <- (ifelse(is.na(cong$count.neutral),0,cong$count.neutral/96) - ifelse(is.na(cong$count.reward),0,cong$count.reward/72) )*100
# see % change per correct type
ddply( ddply(cong,.(subj,correct), function(x){ mean(x$countdiff[is.finite(x$countdiff)]) } ), .(correct),function(x){mean(x$V1)})


## number correct
crctcount <- ddply(subset(df,type=="reward"), .(subj, congr,correct), function(x){nrow(x)})
names(crctcount)[4] <- 'count'
crctcount$correct<-factor(crctcount$correct,levels=c(-1:1),labels=c('norsp','wrg','crct'))
crctcount$congr<-factor(crctcount$congr,levels=c(0,1),labels=c('incong','cong'))
crctcount$t <- paste(sep="_",crctcount$congr,crctcount$correct)
subjcrct<-reshape(crctcount, idvar='subj',timevar='t', drop=c('congr','correct'),direction='wide')
subjcrct$cogMincog <- (subjcrct$count.cong_crct/72 - subjcrct$count.incong_crct/24)*100
print( subjcrct[,c('subj','cogMincog')])

## RT
crctRT <- ddply(subset(df,type=="reward"), .(subj, congr,correct), function(x){mean(x$RT)})
names(crctRT )[4] <- 'RT'
crctRT$correct<-factor(crctRT$correct,levels=c(-1:1),labels=c('norsp','wrg','crct'))
crctRT$congr<-factor(crctRT$congr,levels=c(0,1),labels=c('incong','cong'))
crctRT$t <- paste(sep="_",crctRT$congr,crctRT$correct)
subjRT<-reshape(crctRT, idvar='subj',timevar='t', drop=c('congr','correct'),direction='wide')
subjRT$congMincong <- subjRT$RT.cong_crct - subjRT$RT.incong_crct
subjRT$congMincong_wrong <- subjRT$RT.cong_wrg - subjRT$RT.incong_wrg
print( subjRT[,c('subj','congMincong')])


