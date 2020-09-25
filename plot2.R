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
png("plot2.png",width = 480 ,height = 480 )

## Run the plotting
with(hpc,plot(Time,Global_active_power,type = "n",ylab ="Global Active Power (kilowats)" ,xlab = ""))
with(hpc,lines(Time,Global_active_power))

## Close the png device
dev.off()
## Return the working directory to its default value
setwd(cwd)