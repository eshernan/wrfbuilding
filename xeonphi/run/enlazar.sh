#!/bin/bash

###################
# Crea los enlaces a los Vtable
##################

##################
# Check the parameters 
##################
if [ -z "$1" ] ; then 
 TABLEPATH=/home/cecad/domain1/tables
else 
 TABLEPATH=$1
fi

for i in `ls $TABLEPATH`; do
    echo "$TABLEPATH/$i"
    ln -s $TABLEPATH/$i . ;
done
echo "Files linked " 

