#!/bin/bash
SHARED=/home/eshernan/projects/WRF/SHARED
INSTALLERS=$SHARED/installers
export SHARED INSTALLERS
#for gcc compiler
export CC=gcc
export FC=gfortran
export CXX=g++


cd $INSTALLERS
echo "Compiling zlib ###########################"
cd zlib*
./configure --prefix=$SHARED/libs/zlib
make
make install
cd $INSTALLERS
echo "Compiling libpng ###########################"
cd libpng*
CPPFLAGS="-I$SHARED/libs/zlib/include" LDFLAGS="-L$SHARED/libs/zlib/lib"./configure --prefix=$SHARED/libs/libpng #--build=arm
make
make install
cd $INSTALLERS
echo "Compiling jasper ###########################"

cd jasper*
./configure --prefix=$SHARED/libs/jasper
make
make install
cd $INSTALLERS
echo "Compiling mpich ###########################"
cd mpich*
./configure --prefix=$SHARED/libs/mpich --with-slurm=/usr/lib64/slurm --enable-shared
make
make install
cd $INSTALLERS
export  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/mpich/lib
export PATH=$PATH:$SHARED/libs/mpich/bin
echo "Compiling hdf5 ###########################"
cd hdf5*
export CC=mpicc
export FC=mpif90
export 
./configure --prefix=$SHARED/libs/hdf5 --enable-parallel --enable-fortran --enable-shared
make -j 8
make install
cd $INSTALLERS
cd pnetcdf*
CPPFLAGS="-I$SHARED/libs/hdf5/include/ -I$SHARED/libs/mpich/include" LDFLAGS=-L$SHARED/libs/hdf5/lib/ ./configure --prefix=$SHARED/libs/pnetcdf --enable-shared
make
make install
cd $INSTALLERS
echo "Compiling netcdf-c ###########################"
cd netcdf-c*
CPPFLAGS="-I$SHARED/libs/hdf5/include -I$SHARED/libs/mpich/include -I$SHARED/libs/pnetcdf/include" LDFLAGS="-L$SHARED/libs/hdf5/lib/ -L$SHARED/libs/zlib/lib/ -L$SHARED/libs/pnetcdf/lib" ./configure --prefix=$SHARED/libs/netcdf --enable-netcdf-4 --enable-pnetcdf
make
make install
cd $INSTALLERS
echo "Compiling netcdf-fortran ###########################"
cd netcdf-f*
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SHARED/libs/netcdf/lib CPPFLAGS="-I$SHARED/libs/hdf5/include/ -I$SHARED/libs/zlib/include/ -I$SHARED/libs/netcdf/include" LDFLAGS="-L$SHARED/libs/hdf5/lib/ -L$SHARED/libs/netcdf/lib" ./configure --prefix=$SHARED/libs/amd/netcdf --disable-shared
make
make install
cd $INSTALLERS
cd papi
./configure --prefix=$SHARED/libs/papi
make
make install
cd $INSTALLERS
export NETCDF=$SHARED/libs/netcdf/
export HDF5=$SHARED/libs/hdf5
export PHDF5=$SHARED/libs/hdf5
export JASPERLIB=$SHARED/libs/jasper/lib
export JASPERINC=$SHARED/libs/jasper/include
export PATH=$PATH:$SHARED/libs/netcdf/bin/
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
