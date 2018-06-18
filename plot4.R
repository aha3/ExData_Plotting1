# plot 4

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

# first need to combine date and time variables

library(stringr) # use stringr to combine 2 variables, then lubridate to store as POSIXct variable

powerdata <- 
  mutate(powerdata, date_time_text = str_c(Date, Time, sep = "-"),
         datetime = dmy_hms(date_time_text))
# creates 2 additional variables (total of 2075259 obs of 11 variables)

# select only data from dates 2007-02-01 and 2007-02-02

#change to as.Date

powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y") # note that capital Y is necessary

power_feb4 <- filter(powerdata, Date == "2007-02-01" | Date == "2007-02-02")
# 2880 obs of 11 variables


# create 4th plot (4 line graphs in 2x2 layout)

# set up parameters

par(mfcol = c(2, 2)) # setting up 2x2 layout, printing along columns first


# copy of plot 2

with(power_feb4, plot(datetime, Global_active_power, 
                      xlab = "", ylab = "Global Active Power (kilowatts)", 
                      type = "n"))
# creates empty plot with necessary labels
with(power_feb4, lines(datetime, Global_active_power, type = "l", lty = 1))


# copy of plot 3

with(power_feb4, plot(datetime, Sub_metering_1, 
                      col = "black", 
                      xlab = "", 
                      ylab = "Energy sub metering", 
                      type = "n"))
# creates empty plot with necessary labels

# add Sub metering 1

with(power_feb4, lines(datetime, Sub_metering_1, type = "l", col = "black"))

# add Sub metering 2

with(power_feb4, lines(datetime, Sub_metering_2, type = "l", col = "red"))

# add Sub metering 3

with(power_feb4, lines(datetime, Sub_metering_3, type = "l", col = "blue"))


# add legend

legend("topright", 
       lty = 1, # line type equals 1
       col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# add plot 4 (datetime and voltage)

with(power_feb4, plot(datetime, Voltage, 
                      col = "black", 
                      xlab = "datetime", 
                      ylab = "Voltage", 
                      type = "n"))
      # creates empty plot with necessary labels

# add Voltage data

with(power_feb4, lines(datetime, Voltage, type = "l", col = "black"))


# add plot 5 (datetime and global reactive power)

with(power_feb4, plot(datetime, Global_reactive_power, 
                      col = "black", 
                      xlab = "datetime", 
                      ylab = "Global_reactive_power", 
                      type = "n"))
      # creates empty plot with necessary labels

# add Global_reactive_power data

with(power_feb4, lines(datetime, Global_reactive_power, type = "l", col = "black"))


# now copy plot to png file with 480x480 pixels

dev.copy(png, file = "plot4.png", width = 480, height = 480) # this opens the connection
dev.off() # this closes conneciton and makes it viewable (very important!)
