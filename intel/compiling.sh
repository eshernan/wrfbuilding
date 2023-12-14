#!/bin/bash
#source ../download.sh
source ~/intel/oneapi/setvars.sh
BASE=/home/ehernandez/WRF
SHARED=$BASE/SHARED
LIBS=$SHARED/libs
INSTALLERS=$BASE/installer
export SHARED INSTALLERS
#for Intel Cluster Compilers
export CC=icc
export FC=ifort
export CXX=icpc

# #for gcc
# export CC=gcc
# export FC=gfortran
# export CXX=g++
cd $INSTALLERS
echo "-------------------------------------------------"
echo "----------- Compiling ZLIB  ---------------------"
echo "-------------------------------------------------"

cd zlib-1.2.7
./configure --prefix=$LIBS/zlib
make
make install
cd ..
echo "-------------------------------------------------"
echo "----------- Compiling  LIBPNG  ------------------"
echo "-------------------------------------------------"

cd libpng-1.2.50
./configure --prefix=$LIBS/libpng #--build=arm
make
make install
cd ..
echo "-------------------------------------------------"
echo "----------- Compiling JASPER  -------------------"
echo "-------------------------------------------------"

cd jasper-1.900.1
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
#export CFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
#export CXXFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
#export FFLAGS='-O3 -xHost -ip -no-prec-div -static-intel'
# export CXXFLAGS=-03

echo "-------------------------------------------------"
echo "----------- Compiling HDF5  ---------------------"
echo "-------------------------------------------------"

 cd hdf5-1.12.0
./configure --prefix=$LIBS/hdf5 --enable-parallel --enable-fortran  --enable-cxx  --enable-optimization=high --with-default-api-version=v18
make
make install
cd ..
echo "-------------------------------------------------"
echo "----------- Compiling PNETCDF  ------------------"
echo "-------------------------------------------------"

cd pnetcdf-1.12.2
CPPFLAGS="-I$LIBS/hdf5/include/" LDFLAGS=-L$LIBS/hdf5/lib/ ./configure --prefix=$LIBS/pnetcdf  --enable-shared --enable-static
make
make install
cd ..
echo "-------------------------------------------------"
echo "----------- Compiling NETCDF-C  -----------------"
echo "-------------------------------------------------"
cd netcdf-c-4.9.0
CPPFLAGS="-I$LIBS/hdf5/include/ -I$LIBS/pnetcdf/include" LDFLAGS="-L$LIBS/hdf5/lib/ -L$LIBS/pnetcdf/lib" ./configure --prefix=$LIBS/netcdf --enable-netcdf-4 --enable-pnetcdf -enable-shared
make
make install
cd ..

echo "-------------------------------------------------"
echo "----------- Compiling NETCDF-FORTRAN  -----------"
echo "-------------------------------------------------"

cd netcdf-fortran-4.6.0
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBS/netcdf/lib CPPFLAGS="-I$LIBS/hdf5/include/ -I$LIBS/netcdf/include" LDFLAGS="-L$LIBS/hdf5/lib/ -L$LIBS/netcdf/lib" ./configure --prefix=$LIBS/netcdf --enable-shared 
make
make install
cd ..
# cd papi
# ./configure --prefix=$SHARED/libs/papi
# make
# make install
# cd ..
export NETCDF=$LIBS/netcdf
export HDF5=$LIBS/hdf5
export PHDF5=$LIBS/hdf5
export JASPERLIB=$LIBS/jasper/lib
export JASPERINC=$LIBS/jasper/include
export PATH=$PATH:$LIBS/netcdf/bin
