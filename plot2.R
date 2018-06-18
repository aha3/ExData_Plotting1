# plot1

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

powerdata <- read.table("./rawdata/household_power_consumption.txt", 
                        header = TRUE, 
                        sep = ";", 
                        na.strings = "?", 
                        stringsAsFactors = FALSE)

# get a feel for the data
head(powerdata)
dim(powerdata)
names(powerdata)
class(names(powerdata))


# load dplyr

library(dplyr)

as_tibble(powerdata)


library(lubridate)


# create 2nd plot (line graph of Global Active Power)

# first need to combine date and time variables

library(stringr) # use stringr to combine 2 variables, then lubridate to store as POSIXct variable

powerdata <- 
  mutate(powerdata, date_time_text = str_c(Date, Time, sep = "-"),
         date_time = dmy_hms(date_time_text))
    # creates 2 additional variables (total of 2075259 obs of 11 variables)

# select only data from dates 2007-02-01 and 2007-02-02

#change to as.Date

powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y") # note that capital Y is necessary

power_feb2 <- filter(powerdata, Date == "2007-02-01" | Date == "2007-02-02")
  # 2880 obs of 11 variables


# check selected data

head(power_feb2) # starts with 2007-02-01
tail(power_feb2) # ends with 2007-02-02


# plot 

with(power_feb2, plot(date_time, Global_active_power, 
                      xlab = "", ylab = "Global Active Power (kilowatts)", 
                      type = "n"))
  # creates empty plot with necessary labels
with(power_feb2, lines(date_time, Global_active_power, type = "l", lty = 1))


# now copy plot to png file with 480x480 pixels

dev.copy(png, file = "plot2.png", width = 480, height = 480) # this opens the connection
dev.off() # this closes conneciton and makes it viewable (very important!)
