#!/bin/bash 
export OMP_NUM_THREADS=8
MPI_NUM_PROCESS=2
DOMAIN_DIST=numa
HOME_EXECW=/data/bin/3.8/wrf_debug
OUTPUT=/data/profile/sabio/xeonphinode/profile
HOME_DOMAIN=/home/cecad/domains/Bogota1
HOSTS=$HOME_EXECW/hosts.txt
source $HOME_EXECW/.bash_intel17
source $HOME_EXECW/.bash_wrf8
ulimit -s unlimited
cd $HOME_DOMAIN
export PATH=$PATH:$HOME_EXECW
CURRENT_DATE=`date +"%Y%m%d"`
N_HOST=`wc -l $HOSTS| awk '{print $1}'`
echo $HOME_EXEC
LOG="$OUTPUT/wrf_profile_"$MPI_NUM_PROCESS"MPI_"$OMP_NUM_THREADS"OMP_"$N_HOST"_"$CURRENT_DATE"_current_xeon.log"
echo "the log file was saved on : "$LOG
if [ -f "$LOG" ] ; then
  LOG=$LOG"_$(date +"%H_%M_%S")"
fi
START_DATE=$(date +"%s")
MPI_RANKS=$((MPI_NUM_PROCESS*N_HOST))
export KMP_AFFINITY=granularity=fine,compact
echo "The number of MPI process is " $MPI_RANKS >> $LOG
echo "The number of OpenMP process is " $OMP_NUM_THREADS >> $LOG
echo "The thread affinity used is " $KMP_AFFINITY >>$LOG
echo "The domain distribution is " $DOMAIN_DIST >>$LOG
OUTPUT_DIR="performance_$MPI_RANKS""_""$OMP_NUM_THREADS""_""$(date +"%H_%M_%S")"
PROFILE_TYPE=advanced-hotspots

#mpirun -print-rank-map -trace -machine $HOSTS -np $MPI_RANKS -env I_MPI_PIN_DOMAIN $DOMAIN_DIST  $HOME_EXECW/wrf.exe
#-limit=2000#####For profiling performance on one node, 
mpirun -print-rank-map -machine $HOSTS  -np $MPI_RANKS -env I_MPI_PIN_DOMAIN $DOMAIN_DIST amplxe-cl -trace-mpi -result-dir $OUTPUT_DIR -collect advanced-hotspots -knob enable-user-tasks=true -knob analyze-openmp=true  -data-limit=2000 $HOME_EXECW/wrf.exe 
#mpirun -print-rank-map -machine $HOSTS  -np $MPI_RANKS -env I_MPI_PIN_DOMAIN $DOMAIN_DIST $HOME_EXECW/wrf.exe 
#amplxe-cl -result-dir performance_$MPI_RANKS"_"$OMP_NUM_THREADS -collect advanced-hotspots -data-limit=2000 $HOME_EXECW/wrf.exe 
#export I_MPI_PIN_DOMAIN $DOMAIN_DIST  
#$HOME_EXECW/wrf.exe
echo "El resultado fue #?" >> $LOG
END_DATE=$(date +"%s")
echo " Time spend on simulation " >> $LOG
date -u -d "0 $END_DATE sec - $START_DATE sec" +"%H:%M:%S" >> $LOG
echo "finish" >> $LOG

