#!/bin/bash
export BASE_PATH=/global/scratch/users/ejhernandezb/
export NCARG_ROOT=/usr
export JASPERINC=$BASE_PATH/jasper
export NETCDF=$LIBS/netcdf
export JASPERLIB=$BASE_PATH/jasper
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export NCARG_ROOT=/usr
export HDF5=$LIBS/hdf5
export PHDF5=$LIBS/hdf5
export ZLIB=$LIBS/zlib
export LD_LIBRARY_PATH=$LIBS/mpich/lib:$NETCDF/lib:$HDF5/lib:$ZLIB/lib:$LD_LIBRARY_PATH:
export PATH=$PATH:$LIBS/netcdf/bin:$LIBS/mpich/bin
ulimit -s unlimited
ulimit -n unlimited
mpirun $BASE_PATH/domains/mocoa/real.exe
