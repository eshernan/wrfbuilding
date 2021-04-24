#!/bin/bash
#If you have a valid license of Intel Parallel Studio 
# wget https://registrationcenter-download.intel.com/akdlm/irc_nas/tec/17113/parallel_studio_xe_2020_update4_cluster_edition.tgz
INSTALLER_PATH=/home/ehernandez/WRF_BASE/installer
cd $INSTALLER_PATH
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.8.0.tar.gz
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.2.tar.gz 
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
#wget --no-check-certificate https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
#git clone https://bitbucket.org/icl/papi.git
tar -zxvf netcdf-c-4.7.4.tar.gz
tar -zxvf netcdf-fortran-4.5.2.tar.gz
tar -zxvf hdf5-1.12.0.tar.gz
tar -zxvf jasper-1.900.1.tar.gz 
tar -zxvf libpng-1.2.50.tar.gz
tar -zxvf zlib-1.2.7.tar.gz
tar -zxvf pnetcdf-1.12.2.tar.gz
#tar -zxvf mpich-3.0.4.tar.gz
echo " .... done ...."
