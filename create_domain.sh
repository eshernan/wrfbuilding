source setup_env.sh 
cd $SHARED
mkdir $DOMAIN_NAME
cd $DOMAIN_NAME
cp $WRF/run/*.exe .
cp $WRF/run/*.TBL .
cp $WRF/run/*.tbl .
cp $WRF/run/gribmap.txt .
cp $WRF/run/ETAMPNEW_DATA .
cp $WRF/run/RRTMG* .
cp $WPS/*.exe .
cp $WPS/geogrid/GEOGRID.TBL .
cp $WPS/metgrid/METGRID.TBL .
cp $WPS/ungrib/Variable_Tables/Vtable.GFS .

