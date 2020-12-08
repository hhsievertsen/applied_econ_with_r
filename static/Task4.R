# Applied Economics - Lab on DiD and R - Task 4
# Install packages (you only have to do this once)
install.packages("readr")
install.packages("openxlsx")
install.packages("readstata13")
install.packages("dplyr")
# Load packages
library("readr")
library("openxlsx")
library("readstata13")
library("dplyr")
# set working directory
setwd("C:/Users/hhs/")
# use read.dta13 from readstata13 to load a Stata dataset
school_data_1<-read_csv("school_data_1.csv")
school_data_2<-read.dta13("school_data_2.dta")
school_data_3<-read.xlsx("school_data_3.xlsx")
# Merge school_data_1 and school_data_2 and save as school_data_merged 
school_data_merged<-merge(school_data_1,school_data_2,by="person_id")
# Merge school_data_3 with school_data_merged
school_data_merged<-merge(school_data_merged,school_data_3,by=c("person_id","school_id"))
# list the first 6 rows
head(school_data_merged)