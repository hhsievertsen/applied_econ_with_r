library(tidyverse)
library(readstata13)
library(openxlsx)
# simulate a dataset
setwd("C:\\Github\\applied_econ_with_r\\data")
rm(list=ls())
set.seed(1909)
# number of observations
N<-3491
# personal identifier
person_id<-1:N
#person_id<-paste("p",person_id,sep="")
# schoolid
school_id<-sample(1:30,size=N,replace=TRUE)
# treatd school
tread_school=school_id<10
# ability (unobserved)
ability<-rnorm(N)+0.2*tread_school
# random noise
noise<-rnorm(N)
#rct
rct<-1*(runif(N)<0.25)
#predetermined vars
test_year_1<-2+0.5*ability+0.5*rnorm(N)
test_year_2<-2+0.5*ability+0.4*rnorm(N)+0.1*test_year_1+0.1
test_year_3<-2+0.5*ability+0.4*rnorm(N)+0.1*test_year_2+0.15
test_year_4<-2+0.5*ability+0.4*rnorm(N)+0.1*test_year_3-0.05
test_year_5<-2+0.5*ability+0.4*rnorm(N)+0.1*test_year_4+0.021
belowcut<-1*(test_year_5<1.5)
summary(belowcut)
# treated
treated<-1*((1.2*ability+0.25*noise+1.25*rct+3*belowcut)>.85)
summary(treated)
# did
#treated[school_id<10]<-1
# covariates
female<-round(runif(N))
parental_schooling<-10+round(exp(0.5*ability+0.5*rnorm(N)))
parental_lincome<-log(exp(0.33*parental_schooling+0.33*ability+0.33*rnorm(N))*50000)
# outcomes

test_year_6<-2+0.5*ability+0.3*rnorm(N)+0.1*test_year_5+0.4*treated+0.09
test_year_7<-2+0.5*ability+0.3*rnorm(N)+0.05*test_year_6+0.05*test_year_5+0.35*treated+0.1251
test_year_8<-2+0.5*ability+0.3*rnorm(N)+0.1*test_year_7+0.34*treated-0.075
test_year_9<-2+0.5*ability+0.3*rnorm(N)+0.1*test_year_8+0.33*treated-0.095
test_year_10<-2+0.5*ability+0.3*rnorm(N)+0.1*test_year_9+0.32*treated+0.04
learnings<-log(exp(-2+0.5*test_year_10+0.5*ability+rnorm(N))*50000)
summercamp=treated

test_year_5[1]<-NA
test_year_5[sample(1:N,size=5)]<-NA
test_year_6[sample(1:N,size=5)]<-NA
parental_schooling[sample(1:N,size=5)]<-NA

# 1 dataframe without rct etc
df1<-tibble(person_id,school_id,summercamp,female,parental_schooling,parental_lincome,
           test_year_5,test_year_6)

# 2 dataframe with rct
letter<-rct
df2<-tibble(person_id,letter)

# 3 dataframe with rct and more outcomes
df3<-tibble(person_id,test_year_2,test_year_3,test_year_4,
            test_year_7,test_year_8,test_year_9,test_year_10,learnings,school_id)

write_csv(df1,"school_data_1.csv")
#write_csv(df2,"school_data_2.csv")
save.dta13(df2, "school_data_2.dta")
#write_csv(df3,"school_data_3.csv")
write.xlsx(df3, 'school_data_3.xlsx')


school_data_1<-df1
school_data_2<-df2
school_data_3<-df3
school_data_merged<-tibble(person_id,test_year_2,test_year_3,test_year_4,
                           test_year_7,test_year_8,test_year_9,test_year_10,learnings,school_id,letter,summercamp,female,parental_schooling,parental_lincome,
                           test_year_5,test_year_6)

school_data_tidy<-school_data_merged%>%
  pivot_longer(
    cols = starts_with("test_year"),
    names_to = "year",
    names_prefix = "test_year_",
    names_transform = list(year = as.integer),
    values_to = "test_score",
  )

school_data_selected<-filter(school_data_tidy,!is.na(parental_schooling),!is.na(test_score))
write_csv(school_data_selected,"analysisdata.csv")
