#!/bin/bash
#source ../download.sh
SHARED=/home/ehernandez/WRF_BASE
LIBS=$SHARED/libs
INSTALLERS=$SHARED/installer
export SHARED INSTALLERS
#for Intel Cluster Compilers
export CC=icc
export FC=ifort
export CXX=icpc

# #for gcc
# export CC=gcc
# export FC=gfortran
# export CXX=g++
source ~/.bash_intel20
cd $INSTALLERS
cd zlib*
./configure --prefix=$LIBS/zlib
make
make install
cd ..
cd libpng*
./configure --prefix=$LIBS/libpng #--build=arm
make
make install
cd ..
cd jasper*
./configure --prefix=$LIBS/jasper
make
make install
cd ..
# cd mpich*
# ./configure --prefix=$SHARED/libs/mpich --with-slurm=/usr/lib64/slurm --enable-shared
# make
# make install
# cd ..
# export  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/mpich/lib
# export PATH=$PATH:$SHARED/libs/mpich/bin
export CC=mpiicc
export FC=mpiifort
export CXX=mpiicpc
 cd hdf5*
./configure --prefix=$LIBS/hdf5 --enable-parallel --enable-fortran --enable-shared --with-default-api-version=v18
make -j 20
make install
cd ..
cd pnetcdf*
CPPFLAGS="-I$LIBS/hdf5/include/ -I$LIBS/mpich/include" LDFLAGS=-L$$LIBS/hdf5/lib/ ./configure --prefix=$LIBS/pnetcdf --enable-shared
make
make install
cd ..
cd netcdf-c*
CPPFLAGS="-I$LIBS/hdf5/include/ -I$LIBS/mpich/include -I$LIBS/pnetcdf/include" LDFLAGS="-L$LIBS/hdf5/lib/ -L$LIBS/pnetcdf/lib" ./configure --prefix=$LIBS/netcdf --enable-netcdf-4 --enable-pnetcdf
make
make install
cd ..
cd netcdf-f*
FC=mpif90 LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBS/netcdf/lib CPPFLAGS="-I$LIBS/hdf5/include/ -I$LIBS/netcdf/include" LDFLAGS="-L$LIBS/hdf5/lib/ -L$LIBS/netcdf/lib" ./configure --prefix=$LIBS/netcdf --enable-shared
make
make install
cd ..
# cd papi
# ./configure --prefix=$SHARED/libs/papi
# make
# make install
# cd ..
export NETCDF=$LIBS/netcdf/
export HDF5=$LIBS/hdf5
export PHDF5=$LIBS/hdf5
export JASPERLIB=$LIBS/jasper/lib
export JASPERINC=$LIBS/jasper/include
export PATH=$PATH:$LIBS/netcdf/bin/
