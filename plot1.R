## plot1.R

# create 'data' folder

if(!file.exists("data")){
  dir.create("data")
}

# download raw data from provided link

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# creates value with file

download.file(fileURL, destfile = "Raw Dataset.zip")
dateDownloaded <- date() # for your records

list.files(getwd()) # verify that 'Raw Dataset.zip' is there


# unzip the data

unzip(zipfile = "Raw Dataset.zip",exdir="./rawdata")

list.files(getwd())  # verify 'rawdata' is in working directory


# list files included in extracted data

list.files("rawdata/") # household_power_consumption.txt is listed ;)


# read in the data / load the data

powerdata <- read.table("./rawdata/household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)

# get a feel for the data
head(powerdata)
dim(powerdata)
names(powerdata)
class(names(powerdata))


# load dplyr

library(dplyr)

as_tibble(powerdata)

# change date and time from character to appropriate class

powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y") # note that capital Y is necessary

library(lubridate)

powerdata$Time <- hms(powerdata$Time)

head(powerdata$Time)


# select only data from dates 2007-02-01 and 2007-02-02

power_feb <- filter(powerdata, Date == "2007-02-01" | Date == "2007-02-02")

# check selected data

head(power_feb) # starts with 2007-02-01
tail(power_feb) # ends with 2007-02-02

# create 1st plot (histogram of Global Active Power)

with(power_feb, hist(Global_active_power, 
                     col = "red", 
                     main = "Global Active Power", 
                     xlab = "Global Active Power (kilowatts)", 
                     ylab = "Frequency"))


# now copy plot to png file with 480x480 pixels

dev.copy(png, file = "plot1.png", width = 480, height = 480) # this opens the connection
dev.off() # this closes conneciton and makes it viewable (very important!)