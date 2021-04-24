#!/bin/bash 
########################################
# Este archivo correo el modelo de manera automatica 
# 
########################################
if [ "$1" == "" ]; then 
   echo "Se debe indicar el path donde se desea realizar la configuracion,de otro modo se tomara el actual "
   echo "Current path is $PWD"
   BASE=/data/WRF
else
   BASE=$1
fi
ICC=`icc --version | head -1  | awk '{print $3}'`
echo "Using Intel Compiler version $ICC"

if  [ "$ICC" != "16.0.0" ] ; then 
    source ~/.bash_wrfda
fi

RUN=$BASE/run
LINKBASE=$BASE/geodata/tables
GEOPATH=$BASE/geodata/static
GFS_PATH=$BASE/geodata/gfs
DOMAIN_BASE=$BASE/domains

if [ "$2" == "" ]; then
   echo "Se usa el directorio por defecto"
   CURRENT_DOMAIN=current
else
   CURRENT_DOMAIN=$2
fi

if [ "$3" == "" ]; then 
   DATE=`date +%Y%m%d`
   echo "Se usa la fecha actual del sistema, dado que no se han enviado una especifica $DATE"
else
   DATE=$3
fi 

cd $DOMAIN_BASE
if [ ! -d "$CURRENT_DOMAIN" ]; then
  mkdir $CURRENT_DOMAIN 
fi
cd $CURRENT_DOMAIN
#####################################
# Crear los enlaces simbolicos 
# simbolicos de los Vtables
####################################
################################

############################
# Enlanzando archivos de GFS
#############################
echo "using the following date $DATE ..." 
link_grib.csh $GFS_PATH/current/
############################
# geogrid.exe
############################
YEAR=`echo $DATE|cut -b 1-4`
MONTH=`echo $DATE|cut -b 5-6`
DAY=`echo $DATE|cut -b 7-8`
START_DAY=$YEAR"-"$MONTH"-"$DAY
echo "The start Date is $START_DAY"
FINISH_DATE=`date -d "$DATE +24hours" +'%Y-%m-%d'`
echo "The end Date is $FINISH_DATE"
cp $RUN/namelist.wps ./
cp $RUN/namelist.input ./
EYEAR=`echo $FINISH_DATE|cut -b 1-4`
EMONTH=`echo $FINISH_DATE|cut -b 6-7`
EDAY=`echo $FINISH_DATE|cut -b 9-10`
########################################
# Replacing for namelist.wps
#######################################
sed -i 's/START/'"$START_DAY"'/g' namelist.wps
sed -i 's/END/'"$FINISH_DATE"'/g' namelist.wps
sed -i 's#DATA#'"$GEOPATH"'#g' namelist.wps
########################################
# replacing for namelist.input
#######################################
sed -i 's/SYEAR/'"$YEAR"'/g' namelist.input
sed -i 's/SMONTH/'"$MONTH"'/g' namelist.input
sed -i 's/SDAY/'"$DAY"'/g' namelist.input
sed -i 's/EYEAR/'"$EYEAR"'/g' namelist.input
sed -i 's/EMONTH/'"$EMONTH"'/g' namelist.input
sed -i 's/EDAY/'"$EDAY"'/g' namelist.input
enlazar.sh >> /dev/null 
echo "Link the files...."
geogrid.exe &> geogrid.log 
ungrib.exe &>ungrid.log
metgrid.exe &> metgrid.log 
echo "Finish the preprocessing"
echo "Starting the interpolation"
real.exe >> $LOG
echo "validate the data"
if [ `tail -1 rsl.error.0000 | grep -c 'SUCCESS.*COMPLETE'` != 1 ] ; then echo "Error en procesamiento revisar parametros"; exit 0; else echo "Procesamiento finalizao" ; fi
echo "Starting the forecast, please wait and be patience" 
mpirun -np 16 wrf.exe >> $LOG
echo "Finish de processing, please view the guide for run the next step" 
