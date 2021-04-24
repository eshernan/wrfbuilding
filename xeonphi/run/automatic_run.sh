#!/bin/bash 
CURRENT_DATE=`date +"%Y%m%d"`
HOUR=30
PLOT=plot1
##########################################
# Validate the local directory
##########################################

if [ "$1" == "" ] ; then 
  DIRECTORY=/data/WRF
else
  DIRECTORY=$1
fi
ICC=`icc --version | head -1  | awk '{print $3}'`
echo "Using Intel Compiler version $ICC"
if  [ "$ICC" != "16.0.0" ] ; then 
  source ~/.bash_wrfda
fi

export LOG="$DIRECTORY/wrf_""$CURRENT_DATE"_current.log
echo "Using the base path on $DIRECTORY" >>$LOG
DOWNLOAD_DIR=$DIRECTORY/geodata/gfs/current/
cd $DOWNLOAD_DIR
echo " The current date is $CURRENT_DATE" >> $LOG 
echo "start de the execution of download at $(date +"%H:%M:%S")"
#########################
## Download GFS files
########################
descargas.sh $CURRENT_DATE $HOUR >> $LOG 
###################################
# Evaluating the download process
###################################
if [ "$?" -ne 0 ] ; then 
    echo "Error downloading data from ncep, please review   the $LOG file" >> $LOG
else
  echo "finish the download process at $(date +"%H:%M:%S")" >> $LOG
fi 
cd $DIRECTORY/domains

if [ "$2" == "" ] ; then
  EXPERIMENT=current
else
  EXPERIMENT=$2
fi
if [ ! -d  "$EXPERIMENT" ] ; then 
  echo "Creating a new Directory $EXPERIMENT " >> $LOG
  mkdir $EXPERIMENT
fi 
echo "Using experiment path $EXPERIMENT" >> $LOG 
cd $EXPERIMENT

#########################
## Running the forecast 
########################
modelo.sh $DIRECTORY $EXPERIMENT $CURRENT_DATE
echo " The current name is $CURRENT_NAME ..." >> $LOG
echo " The new name is $NEW_NAME ..." >> $LOG

if [ ! -d "$PLOT" ] ; then 
   mkdir  $PLOT
fi 
cd $PLOT
echo "Delete current data and graphics ....." >> $LOG
rm -Rf *.png *.csv *.gif 
PlotSalidaCienaga.py  $CURRENT_DATE
echo "Creating GIF files " >> $LOG
animar.sh $CURRENT_DATE
echo "Compress the result">>$LOG
tar -cvf PronosticoCienaga_$CURRENT_DATE.tar *.png *.csv *.gif
gzip PronosticoCienaga_$CURRENT_DATE.tar 
echo "Transfer file to remote site ...$(date +"%H:%M:%S")" >> $LOG
scp  PronosticoCienaga_$CURRENT_DATE.tar.gz  sigematftp@200.69.103.53:/home/sigematftp/wrf
echo "Finish the running process at i$(date +"%H:%M:%S")" >> $LOG

