#!/bin/bash
SHARED=/global/scratch/users/ejhernandezb/
INSTALLERS=/global/home/users/ejhernandezb/installer
export SHARED INSTALLERS
#for gcc compiler
export CC=gcc
export FC=gfortran
export CXX=g++




cd $INSTALLERS
cd zlib*
./configure --prefix=$SHARED/libs/zlib
make
make install
cd ..
cd lipng*
./configure --prefix=$SHARED/libs/libpng #--build=arm
make
make install
cd ..
cd jasper*
./configure --prefix=$SHARED/libs/jasper
make
make install
cd ..
cd mpich*
./configure --prefix=$SHARED/libs/mpich --with-slurm=/usr/lib64/slurm --enable-shared
make
make install
cd ..
export  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/mpich/lib
export PATH=$PATH:$SHARED/libs/mpich/bin
cd hdf5*
./configure --prefix=$SHARED/libs/hdf5 --enable-parallel --enable-fortran --enable-shared
make -j 20
make install
cd ..
cd pnetcdf*
CPPFLAGS="-I$SHARED/libs/hdf5/include/ -I$SHARED/libs/mpich/include" LDFLAGS=-L$SHARED/libs/hdf5/lib/ ./configure --prefix=$SHARED/libs/pnetcdf --enable-shared
make
make install
cd ..
cd netcdf-c*
CPPFLAGS="-I$SHARED/libs/hdf5/include/ -I$SHARED/libs/mpich/include -I$SHARED/libs/pnetcdf/include" LDFLAGS="-L$SHARED/libs/hdf5/lib/ -L$SHARED/libs/pnetcdf/lib" ./configure --prefix=$SHARED/libs/amd/netcdf --enable-netcdf-4 --enable-pnetcdf
make
make install
cd ..
cd netcdf-f*
FC="mpif90 -f90=flang" LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/amd/netcdf/lib CPPFLAGS="-I$SHARED/libs/hdf5/include/ -I$SHARED/libs/amd/netcdf/include" LDFLAGS="-L$SHARED/libs/hdf5/lib/ -L$SHARED/libs/netcdf/lib" ./configure --prefix=$SHARED/libs/amd/netcdf --disable-shared
make
make install
cd ..
cd papi
./configure --prefix=$SHARED/libs/papi
make
make install
cd ..
export NETCDF=$SHARED/libs/amd/netcdf/
export HDF5=$SHARED/libs/hdf5
export PHDF5=$SHARED/libs/hdf5
export JASPERLIB=$SHARED/libs/jasper/lib
export JASPERINC=$SHARED/libs/jasper/include
export PATH=$PATH:$SHARED/libs/amd/netcdf/bin/
