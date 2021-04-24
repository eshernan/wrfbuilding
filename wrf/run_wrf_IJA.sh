#!/bin/bash
# HRT
# Colombia- Ituango - La Mojana
# Variables de entorno
source /fsx/intel/parallel_studio_xe_2020.0.088/bin/psxevars.sh intel64
export BASE_PATH=/fsx/WRF
export CC=icc
export FC=ifort
export CXX=icpc
export LD_LIBRARY_PATH=$BASE_PATH/libs/netcdf/lib:$BASE_PATH/libs/hdf5/lib/:$LD_LIBRARY_PATH
export LIBRARY_PATH=$BASE_PATH/libs/netcdf/lib:$LIBRARY_PATH
export CPATH=$BASE_PATH/libs/netcdf/lib:$CPATH
export NETCDF=$BASE_PATH/libs/netcdf
export CPPFLAGS=-I$BASE_PATH/libs/netcdf/include:-I$BASE_PATH/libs/hdf5/include:-I$BASE_PATH/libs/zlib/include:-I$BASE_PATH/libs/libpng/include
export LDFLAGS=-L$BASE_PATH/libs/netcdf/lib:-L$BASE_PATH/libs/hdf5/lib:-L$BASE_PATH/libs/zlib/lib:-L$BASE_PATH/libs/libpng/libs
PATH=$BASE_PATH/libs/mpich/bin:$PATH ; export PATH
export LD_LIBRARY_PATH=$BASE_PATH/libs/mpich/lib:$LD_LIBRARY_PATH
export NCARG_ROOT=/usr
export JASPERINC=$BASE_PATH/jasper
export JASPERLIB=$BASE_PATH/jasper
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export NCARG_ROOT=/usr
export HDF5=$BASE_PATH/libs/hdf5
#source /fsx/intel/impi/2019.6.166/intel64/bin/mpivars.sh -arch intel64 -platform linux
ulimit -s unlimited
ulimit -n unlimited

#Años y meses a correr
anyoinicial=(2018)
mesinicial=(05)
diainicial=(09)
anyofinal=(2018)
mesfinal=( 05)
#diafinal=(02 30 31 01 02 03)
diafinal=(diainicial -d "3 days" +%d`)

# Creación de miembros para simulaciones estocasticas
miembro=(1 2 3 4 5 6 7 8 9 10)
i=0
while [ $i -lt 1 ]; do

 echo "Corrida $((i+1))"
 echo "Periodo a correr: ${anyoinicial[$i]}-${mesinicial[$i]}-${diainicial[$i]}_00:00:00 a ${anyofinal[$i]}-${mesfinal[$i]}-${diafinal[$i]}_00:00:00"
 
 #Corro el WPS
 cd /home/geofisico/WRF/WRF_Mocoa/dominios/


 #Elimino los datos de entrada de la corrida anterior

rm -v met_em.d01.*
rm -v PFILE\:*
rm -v FILE\:*

#Genero el namelist.wps para la corrida (Ensamble)
# 
cat << Fin | sed -e 's/#.*//; s/  *$//' > /home/geofisico/WRF/WRF_Mocoa/dominios/namelist.wps_${anyoinicial[$i]}${mesinicial[$i]}${diainicial[$i]}

&share
 wrf_core = 'ARW',
 max_dom = 2,
 start_date = '${anyoinicial[$i]}-${mesinicial[$i]}-${diainicial[$i]}_00:00:00', 
 end_date   = '${anyofinal[$i]}-${mesfinal[$i]}-${diafinal[$i]}_00:00:00', 
 interval_seconds = 10800,
 io_form_geogrid = 2,
/

&geogrid
 parent_id         = 1,1,
 parent_grid_ratio = 1,3,
 i_parent_start    = 1,59,
 j_parent_start    = 1,52,
 e_we          = 262,385,
 e_sn          = 355,733,
 geog_data_res = '30s','30s',
 dx = 4000,
 dy = 4000,
 map_proj =  'mercator',
 ref_lat   = 7.342,
 ref_lon   = -74.411,
 truelat1  = 7.342,
 truelat2  = 0,
 stand_lon = -74.411,
 geog_data_path = '/home/hart/Files_HRT/CIAHM/Research/WRF_IJA/domains',
 opt_geogrid_tbl_path = '/home/hart/Files_HRT/CIAHM/Research/WRF_IJA/domains/dominio1/',
 ref_x = 131.0,
 ref_y = 177.5,
/
	
&ungrib
 out_format = 'WPS',
 prefix = 'FILE',
/

&metgrid
 fg_name = 'FILE',
 io_form_metgrid = 2,
 opt_output_from_metgrid_path = './',
 opt_metgrid_tbl_path = './',
/

Fin

#Ahora, copio el namelist generado al que se utiliza en la corrida
 rm -v namelist.wps
 cp -v namelist.wps_${anyoinicial[$i]}${mesinicial[$i]}${diainicial[$i]} namelist.wps

 #Y empiezo la ejecución de los programas del WPS
 time mpiexec -l -n 2 ./geogrid.exe
 #
 rm -v Vtable
 rm -v GRIBFILE.A*
 ln -sf /home/geofisico/WRF/v381/WPS/ungrib/Variable_Tables/Vtable.GFS Vtable
# ./link_grib.csh /home/geofisico/WRF/WRF_Mocoa/GFS_data/gfsanl_
./link_grib.csh /home/geofisico/WRF/WRF_Mocoa/GFS_data/grib1/gfs_* # posición de los datos
 time mpiexec -l -n 1 ./ungrib.exe

j=1
while [ $j -lt 11 ]; do
 echo "Ensamble ${miembro[$j]}"


 #Genero el namelist.input para la corrida
 cat << Fin | sed -e 's/#.*//; s/  *$//' > /home/geofisico/WRF/WRF_Mocoa/dominios/namelist.input${anyoinicial[$((i))]}${mesinicial[$((i))]}${diainicial[$i]}Ens_${miembro[$j]}
 
 &time_control
 run_days                            = 3,
 run_hours                           = 0,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = ${anyoinicial[$i]}, ${anyoinicial[$i]}, ${anyoinicial[$i]},
 start_month                         = ${mesinicial[$i]},   ${mesinicial[$i]},   ${mesinicial[$i]},
 start_day                           = ${diainicial[$i]},   ${diainicial[$i]},   ${diainicial[$i]},
 start_hour                          = 00,   00,   00,
 start_minute                        = 00,   00,   00,
 start_second                        = 00,   00,   00,
 end_year                            = ${anyofinal[$i]}, ${anyofinal[$i]}, ${anyofinal[$i]},
 end_month                           = ${mesfinal[$i]},   ${mesfinal[$i]},   ${mesfinal[$i]},
 end_day                             = ${diafinal[$i]},   ${diafinal[$i]},   ${diafinal[$i]},
 end_hour                            = 00,   06,   06,
 end_minute                          = 00,   00,   00,
 end_second                          = 00,   00,   00,
 interval_seconds                    = 10800
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 60,  60,   10,
 frames_per_outfile                  = 1000, 1000, 1000,
 restart                             = .false.,
 restart_interval                    = 5000,
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 /

 &domains              
 use_adaptive_time_step              = .true.
 step_to_output_time                 = .true. 
 target_cfl                          = 1.2, 
 target_hcfl                         = .84,
 max_step_increase_pct               =  5,  51  51,
 starting_time_step                  = -1,  -1, -1,
 max_time_step                       = -1,       
 min_time_step                       = -1,    
 adaptation_domain                   = 1,      
 time_step                = 24,
 time_step_fract_num      = 0,
 time_step_fract_den      = 1,
 max_dom                  = 2,
 s_we                     = 1,        1,
 e_we                     = 262,      385,
 s_sn                     = 1,        1,
 e_sn                     = 355,      733,
 s_vert                   = 1,        1, 
 e_vert                   = 34,       34,
 num_metgrid_levels       = 34,
 dx                       = 4000, 1333.333,
 dy                       = 4000, 1333.333,
 grid_id                  = 1,        2,
 parent_id                = 1,        1,
 i_parent_start           = 1,       59,
 j_parent_start           = 1,       52,
 parent_grid_ratio        = 1,        3,
 parent_time_step_ratio   = 1,        3,
 feedback                 = 1,
 smooth_option            = 0,
/

 &physics
 mp_physics                          = 8,     8,     2,   2,
 ra_lw_physics                       = 1,     1,     1,   4,
 ra_sw_physics                       = 1,     1,     1,   4,
 radt                                = 10,    10,    10,  10,
 sf_sfclay_physics                   = 2,     2,     2,   2,
 sf_surface_physics                  = 2,     2,     2,   2,
 bl_pbl_physics                      = 2,     2,     1,   2,
 bldt                                = 0,     0,     0,   0,
 cu_physics                          = 0,     0,     0,   0,
 cudt                                = 5,     0,     0,   5,
 isfflx                              = 1,
 ifsnow                              = 0,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,  
 sf_urban_physics                    = 0,     0,     0,   0,
 /
&stoch
 stoch_force_opt                     = 1,      1,     1,          
 stoch_vertstruc_opt                 = 1,      1,     1,  
 tot_backscat_psi                    = 1.E-05, 1.E-05, 1.E-05,  
 tot_backscat_t                      = 1.E-06, 1.E-06, 1.E-06,
 ztau_psi                            = 10800.0,      
 ztau_t                              = 10800.0,
 rexponent_psi                       = -1.83,  
 rexponent_t                         = -1.83,
 zsigma2_eps                         = 0.0833,    
 zsigma2_eta                         = 0.0833, 
 kminforc                            = 1,    
 lminforc                            = 1,
 kminforct                           = 1,
 lminforct                           = 1
 kmaxforc                            = 1000000,   
 lmaxforc                            = 1000000,          
 kmaxforct                           = 1000000,  
 lmaxforct                           = 1000000,    
 perturb_bdy                         = 1, 
 nens                                = ${miembro[$j]},
 /

 &fdda
 /

 &dynamics
 w_damping                           = 0,
 diff_opt                            = 3,
 km_opt                              = 4,
 diff_6th_opt                        = 2,      2,      2,       2,
 diff_6th_factor                     = 0.12,   0.12,   0.12,    0.12,
 base_temp                           = 290.
 damp_opt                            = 3,
 zdamp                               = 5000.,  5000.,  5000.,   5000.,
 dampcoef                            = 0.2,    0.2,    0.2      0.2,
 khdif                               = 0,      0,      0,       0,
 kvdif                               = 0,      0,      0,       0,
 non_hydrostatic                     = .true., .true., .true., ,.true.,
 moist_adv_opt                       = 1,      1,      1,     1,
 scalar_adv_opt                      = 1,      1,      1,     1,
 /

 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 specified                           = .true., .false.,.false., .false.,
 nested                              = .false., .true., .true., .true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /
Fin


 time mpiexec -l -n 1 ./metgrid.exe
 rm -v FILE\:*
 rm -v PFILE\:*

 #Empiezo la corrida del WRF como tal

 #Elimino los archivos intermedios de la corrida anterior
 rm -v wrfout_*
 rm -v wrfrst_d01_*
 rm -v wrfbdy_d01
 rm -v wrflowinp_d01
 rm -v wrfinput_d01

 
Fin

 #Ahora, copio el namelist generado al que se utiliza en la corrida
 rm -v namelist.input
 cp -v namelist.input${anyoinicial[$((i))]}${mesinicial[$((i))]}${diainicial[$i]}Ens_${miembro[$j]} namelist.input

 time mpiexec -l -n 16 ./real.exe 2>&1 | tee real.txt
 time mpiexec -l -n 16 ./wrf.exe 2>&1 | tee wrf.txt

 #mkdir /home/geofisico/WRF/WRF_Mocoa/dominios/Salida${anyoinicial[$((i))]}${mesinicial[$((i))]}${diainicial[$i]}_${miembro[$j]}

 #mv -v wrfout_d01_* /home/geofisico/WRF/WRF_Mocoa/dominios/Salida${anyoinicial[$((i))]}${mesinicial[$((i))]}${diainicial[$i]}_${miembro[$j]}

 let j++
done

 let i++
done
