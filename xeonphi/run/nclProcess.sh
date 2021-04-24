#!/bin/bash
fileout=$(ls wrfout_d01*.nc)
fileem=$(ls met_em*.nc)
nclfile=$1
echo "El archivo es $fileout"
sed  -i '18s/wrfout.*\"\b/'"$fileout\",\""'/g' $nclfile
sed  -i '59s/met_em.*\"\b/'"$fileout\",\""'/g' $nclfile
