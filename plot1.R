## Creating a working directory 
cwd <- getwd()
wd <- "household_power_consumption"
if (dir.exists(wd)){
    setwd(paste(cwd,wd,sep = "/"))
} else {
    dir.create(wd)
    setwd(paste(cwd,wd,sep = "/"))
}
## Downloading and unzipping the dataset
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","hh_power_cons.zip")
unzip("hh_power_cons.zip")
## Loading the set 
hpc <- read.table("household_power_consumption.txt",header = TRUE, sep = ";", na.strings = "?",stringsAsFactors = FALSE)
## Subsetting only first and second days of Feb-2007
hpc <- subset(hpc,grepl("^[1|2]/2/2007",Date))
## Changing Date and Time column classes to Date and Time 
hpc$Date <- as.Date(hpc$Date,format="%e/%m/%Y")
hpc$Time <- strptime(paste(as.character(hpc$Date,format = "%Y-%m-%d"),hpc$Time),format="%Y-%m-%d %H:%M:%S" )
## Open the png device
png("plot1.png",width = 480 ,height = 480 )

## Run the histogram first without axes 
hist(hpc$Global_active_power,col = "red",main = "Global Active Power",xlab = "Global Active Power (kilowats)",xlim=c(0,6),ylim=c(0,1200),axes = FALSE)
## Show the Y axis
axis(2)
## Show the X axis after adjusting the ticks and its labels 
axis(1,at=seq(0,max(hpc$Global_active_power,na.rm = TRUE),by=2.0),labels = seq(0,6,by=2.0))

## Close the png device
dev.off()
## Return the working directory to its default value
setwd(cwd)