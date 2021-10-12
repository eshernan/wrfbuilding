#!/bin/sh

source ../setup_env.sh

cd $SHARED/domains/$DOMAIN_NAME/$GFS_DATA

# Script for fast downloading of GFS data in grib2 format
# Select levels, variables and subregion of interest
#
## D A T E  #################################################################
##
if [ "$1" = help ] ; then
    echo "usage: $0 [YYYYMMDD] date of GFS run to be downloaded (last month only)"
    return
fi
if [ "$1" != "" ] ; then
    day=$1
else
    day=$(date +%Y%m%d)
fi

 echo "INPUT DATA: " $day $1

#############################################################################
# Definition of working directory

# Definition of local directory where files are stored
dirgfs=$SHARED/domains/$DOMAIN_NAME/$GFS_DATA/$day
mkdir -p $dirgfs

# Definition of forecast cycle and forecast hours
FCY='00'
# Definition of Level 
GFS_PLEVEL='p25'
# Using 7 days of operational data 7 days * 4 periods of day  * 6 hours = 168
fhrs=`echo {000..169..6}`
#fhrs='000 003 006'
#fhrs='000 003 006 009 012 015 018 021 024 027 030 033 036 039 042 045 048 051 054 057 060 063 066 069 072 075 078 081 084 087 090 093 096 099 102 105 108 111 114 117 120'

rm -f $dirgfs/gfs_ok
cd $dirgfs
rm -f GRIBFILE* grib2file* full_grib_file

declare -a seq_to_sort=( ["10#000"]="AAA" ["10#003"]="AAB" ["10#006"]="AAC" ["10#009"]="AAD" ["10#012"]="AAE" ["10#015"]="AAF" ["10#018"]="AAG" ["10#021"]="AAH" ["10#024"]="AAI" ["10#027"]="AAJ" ["10#030"]="AAK" ["10#033"]="AAL" ["10#036"]="AAM" ["10#039"]="AAN" ["10#042"]="AAO" ["10#045"]="AAP" ["10#048"]="AAQ" ["10#051"]="AAR" ["10#054"]="AAS" ["10#057"]="AAT" ["10#060"]="AAU" ["10#063"]="AAV" ["10#066"]="AAW" ["10#069"]="AAX" ["10#072"]="AAY" ["075"]="AAZ" ["10#078"]="ABA" ["10#081"]="ABB" ["10#084"]="ABC" ["10#087"]="ABD" ["10#090"]="ABE" ["10#093"]="ABF" ["10#096"]="ABG" ["10#099"]="ABH" ["102"]="ABI" ["105"]="ABJ" ["10#108"]="ABK" ["111"]="ABL" ["114"]="ABM" ["117"]="ABN" ["120"]="ABO" )

for fhr in $fhrs
do
    echo "Downloading gfs file"
    current_file="s3://noaa-gfs-bdp-pds/gfs.${day}/${FCY}/atmos/gfs.t${FCY}z.pgrb2.0${GFS_PLEVEL}.f${fhr}"
    aws s3 cp $current_file .
    # sleep 1
done

wait

#########################################
echo "End of Download"
exit 0
