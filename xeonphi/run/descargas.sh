#!/bin/bash 
BASE_GFS="ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."
BASE_WRFDA="ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."

if [ "$1" == ""] ; then 
  echo "Debe indicar la fecha en que quiere realizar la desarga en formato AAAAMMDDD Eje: 20151101"
  exit 0;
else
  fecha=$1
fi

if [ "$2" == ""] ; then 
  echo "Debe indicar la hora limite de descarga en multiplos de 6 ejemplo 18, 24, etc"
  exit 0;
else 
  END=$2
fi 
#####################
### Toma de fecha actual
#####################
#fecha=`date +%G%m%d --date '$1 days ago'`;
fecha1="$fecha""00"
BASE="$BASE_GFS$fecha1""/"
#####################
# Establecer los archivos a descargar
####################
fileBase="gfs.t00z.pgrb2.0p"
fileWrfda1="gdas1.t00z.gpsro.tm00.bufr_d"
fileWrfda2="gdas1.t00z.gpsro.tm00.bufr_d"
press="50"
hour=".f0"
##################################
# Activar el job control para enviar procesos paralelos
#################################
set -m
#######################
# CONFIG DATA FOR DOWNLOAD
######################
START=0
STEP=6

for i in $(eval echo "{$START..$END..$STEP}") ; do 
  if [ "$i" -le 10 ] ; then
    wget  "$BASE$fileBase$press$hour"0"$i" &  
  else
    wget "$BASE$fileBase$press$hour$i"     &
  fi
done

########################
# Revisar que todos se hayan realizado en paralelo 
#########################

while [ 1 ]; do fg 2> /dev/null; [ $? == 1 ] && break; done

echo "finish"

