#!/bin/bash
SHARED=/global/scratch/users/ejhernandezb/
export SHARED
export CC=clang
export FC=flang
export CXX=clang++

export NETCDF=$SHARED/libs/amd/netcdf
export PNETCDF=$SHARED/libs/pnetcdf
export HDF5=$SHARED/libs/hdf5
export PHDF5=$SHARED/libs/hdf5
export JASPERLIB=$SHARED/libs/jasper/lib
export JASPERINC=$SHARED/libs/jasper/include
export ZLIB=$SHARED/libs/zlib
export MPICH=$SHARED/libs/mpich
export PAPI_DIR=$SHARED/libs/papi
export PATH=$PATH:$NETCDF/bin:$MPICH/bin:$PAPI_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPICH/lib:$NETCDF/lib:$HDF5/lib:$ZLIB/lib:$PNETCDF/lib:$PAPI_DIR/lib
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
