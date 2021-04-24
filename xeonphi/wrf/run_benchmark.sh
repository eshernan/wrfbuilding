#!/bin/bash 
echo "Running benchmarking to WRF Microphysics"
MP="1 3 6 8 10"
DOMAIN_PATH=/home/cecad/domains/Bogota1
SCRIPT_BENCH=/data/bin/3.8/wrf/lauch_omp_mpi_wrf_bech.sh
cd $DOMAIN_PATH
LINE=`grep -n "mp_physics" namelist.input | awk -F: '{print $1}'`
for valoresA in  $MP 
do 
 # the the current value for microphysics
  INITIAL_VALUE=`grep "mp_physics" namelist.input | awk -F= '{print $2}' | awk -F, '{print $1}'| tr -d [:blank:]`
  #echo "The value to replace is $INITIAL_VALUE on line $LINE"
  #echo "The initial value : $INITIAL_VALUE"
  STRING_R=`echo "$LINE""s"/$INITIAL_VALUE/$valoresA"/g"`
  #echo "$LINE""s"/$INITIAL_VALUE/$valoresA"/g"
  #echo "The string is $STRING_R"
  # replace the default values on microphysics
  sed -i "$LINE""s"/$INITIAL_VALUE/$valoresA"/g" namelist.input
#  sed -i "$STRING_G" namelist.input
  # running the benchmark
  source $SCRIPT_BENCH $valoresA
  sleep 10s
done
echo "Finish the benchmark"

