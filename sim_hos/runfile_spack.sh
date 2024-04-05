#!/bin/bash

#SBATCH --job-name=amr_waves
#SBATCH --account=hfm
#SBATCH --nodes=114
#SBATCH --time=48:00:00
#SBATCH --output=out.%x_%j
##SBATCH --qos=high
##SBATCH --switches=2

#module purge
#module load gcc
module load mpt
#module load cmake

#export EXAWIND_DIR=/nopt/nrel/ecom/exawind/exawind-2020-09-21/install/gcc

source /home/lmartine/.bash_profile 
export SPACK_MANAGER=${HOME}/spack-manager
source ${SPACK_MANAGER}/start.sh
spack-start

echo $SPACK_MANAGER
echo ${SPACK_MANAGER}

#spack env activate -d /projects/wakedynamics/tony/amr-wind-oct-16-2023
#spack load amr_wind@main

#quick-activate /projects/wakedynamics/tony/amr-wind-oct-16-2023
quick-activate ~/environment_amrwind_waves2amr
spack load amr-wind@main

ranks_per_node=36
mpi_ranks=$(expr $SLURM_JOB_NUM_NODES \* $ranks_per_node)
export OMP_NUM_THREADS=1  # Max hardware threads = 4
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

echo "Job name       = $SLURM_JOB_NAME"
echo "Num. nodes     = $SLURM_JOB_NUM_NODES"
echo "Num. MPI Ranks = $mpi_ranks"
echo "Num. threads   = $OMP_NUM_THREADS"
echo "Working dir    = $PWD"

rm -rf post_processing

#srun -n 512  -c 1 --cpu_bind=cores amr_wind abl_multiphase_laminar.inp # > out.log 2>&1
srun -n 4096  -c 1 --cpu_bind=cores amr_wind abl_multiphase_laminar.inp # > out.log 2>&1
