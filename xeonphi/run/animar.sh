#!/bin/bash 
######################################
### Script to create animation on gif file 
#####################################
Date=$1
if [ "$Date" == "" ]; then 
   Date=`date +%Y%m%d`
   echo "You dont't use a specific date, the default current date is used $Date"
fi
echo "Generating forecast animation ....."
convert $(for i in *lluvia.png; do printf -- "-delay 100 %s -loop 0 " $i; done;)    Pronostico-cienaga-wrf_"$Date"-lluvia.gif
convert $(for i in *vientos.png; do printf -- "-delay 100 %s -loop 0 " $i; done;)   Pronostico-cienaga-wrf_"$Date"-viento.gif
convert $(for i in *humedad.png; do printf -- "-delay 100 %s -loop 0 " $i; done;)   Pronostico-cienaga-wrf_"$Date"-humedad.gif
convert $(for i in *temperatura.png; do printf -- "-delay 100 %s -loop 0 " $i; done;)   Pronostico-cienaga-wrf_"$Date"-temperatura.gif
