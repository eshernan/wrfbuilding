#!/bin/bash
export BASE_PATH=/global/scratch/users/ejhernandezb/
export NCARG_ROOT=/usr
export JASPERINC=$BASE_PATH/jasper
export NETCDF=$BASE_PATH/libs/netcdf
export JASPERLIB=$BASE_PATH/jasper
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export NCARG_ROOT=/usr
export HDF5=$BASE_PATH/libs/hdf5
export PHDF5=$BASE_PATH/libs/hdf5
export ZLIB=$BASE_PATH/libs/zlib
export LD_LIBRARY_PATH=$BASE_PATH/libs/mpich/lib:$NETCDF/lib:$HDF5/lib:$ZLIB/lib:$LD_LIBRARY_PATH:
export PATH=$PATH:$BASE_PATH/libs/netcdf/bin:$BASE_PATH/libs/mpich/bin
ulimit -s unlimited
ulimit -n unlimited
mpirun $BASE_PATH/domains/mocoa/real.exe
