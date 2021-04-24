SHARED=/global/scratch/users/ejhernandezb/
INSTALLERS=/global/home/users/ejhernandezb/installer
export SHARED INSTALLERS
export CC=mpicc
export FC=mpif90
export NETCDF=$SHARED/libs/netcdf
export PNETCDF=$SHARED/libs/pnetcdf
export HDF5=$SHARED/libs/hdf5
export PHDF5=$SHARED/libs/hdf5
export JASPERLIB=$SHARED/libs/jasper/lib
export JASPERINC=$SHARED/libs/jasper/include
export ZLIB=$SHARED/libs/zlib
export PAPI_DIR=$SHARED/libs/papi
export PATH=$PATH:$SHARED/libs/netcdf/bin:$SHARED/libs/mpich/bin:$PAPI_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/mpich/lib:$NETCDF/lib:$HDF5/lib:$ZLIB/lib:$PNETCDF/lib:$PAPI_DIR/lib
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
