#!/bin/bash
#
#SBATCH --job-name=wrf.exe
#SBATCH --output=wrf_output.log
#SBATCH --time=480
#SBATCH --partition=rome
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=32

#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=4
module load intel/2020.1.21
source /global/home/users/ejhernandezb/config_run.sh
cd /global/scratch/users/ejhernandezb/domains/mocoa-intel/
srun --mpi=pmi2 -n 256  ./wrf.exe
