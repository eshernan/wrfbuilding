#!/bin/bash
#If you have a valid license of Intel Parallel Studio 
# wget https://registrationcenter-download.intel.com/akdlm/irc_nas/tec/17113/parallel_studio_xe_2020_update4_cluster_edition.tgz
source ./setup_env.sh
cd $INSTALLER_PATH
wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
wget https://parallel-netcdf.github.io/Release/pnetcdf-1.13.0.tar.gz
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.4/src/hdf5-1.14.4-3.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.11.tar.gz
#wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
#git clone https://bitbucket.org/icl/papi.git
tar -zxvf netcdf-c-4.9.2.tar.gz
tar -zxvf netcdf-fortran-4.6.1.tar.gz
tar -zxvf hdf5-1.14.4.tar.gz
tar -zxvf jasper-1.900.1.tar.gz 
tar -zxvf libpng-1.2.50.tar.gz
tar -zxvf zlib-1.2.11.tar.gz
tar -zxvf pnetcdf-1.13.0.tar.gz
#tar -zxvf mpich-3.0.4.tar.gz
echo " .... required libs download sucessful ...."
cd $SHARED
git clone https://github.com/wrf-model/WPS.git
git clone https://github.com/wrf-model/WRF.git
echo " .... WRF and WPS download sucessful ...."
mkdir GEO_STATIC_DATA
cd GEO_STATIC_DATA
export GEO_STATIC_DATA=$PWD
wget --no-check-certificate  https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz

tar -zxvf geog_high_res_mandatory.tar.gz
cd ..



