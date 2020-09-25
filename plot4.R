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
png("plot4.png",width = 480 ,height = 480 )

## Run the plotting
par(mfcol=c(2,2))

## First Plot
with(hpc,plot(Time,Global_active_power,type = "n",ylab ="Global Active Power" ,xlab = ""))
with(hpc,lines(Time,Global_active_power))

## Second Plot
numt <- as.numeric(as.POSIXct(hpc$Time))
minday <- as.character(min(hpc$Time,na.rm = TRUE),"%a")
medday <- as.character(median(hpc$Time,na.rm = TRUE)+60,"%a")
maxday <- as.character(max(hpc$Time,na.rm = TRUE)+60,"%a")
sub_total <- with(hpc,Sub_metering_1+Sub_metering_2+Sub_metering_3)
peak <- with(hpc,max(max(Sub_metering_1,na.rm = TRUE),max(Sub_metering_2,na.rm = TRUE),max(Sub_metering_3,na.rm = TRUE)))
with(hpc,plot(Time,sub_total,type = "n",ylab ="Energy sub metering" ,xlab = "",axes = F,ylim=c(0,peak)))
with(hpc,lines(Time,Sub_metering_1,col="black"))
with(hpc,lines(Time,Sub_metering_2,col="red"))
with(hpc,lines(Time,Sub_metering_3,col="blue"))
box(which="plot",lty = 1)
axis(1,at=c(min(numt),median(numt),max(numt)),labels = c(minday,medday,maxday))
axis(2,at=seq(0,30,by=10),labels = seq(0,30,by=10))
legend("topright",lty=c(1,1,1),col =c("black","red","blue"),legend = names(hpc)[7:9],bty="n")

## Third Plot
with(hpc,plot(Time,Voltage,type = "n",ylab ="Voltage" ,xlab = "datetime"))
with(hpc,lines(Time,Voltage))

## Fourth Plot
with(hpc,plot(Time,Global_reactive_power,type = "n",xlab = "datetime"))
with(hpc,lines(Time,Global_reactive_power))

## Close the png device
dev.off()
## Return the working directory to its default value
setwd(cwd)