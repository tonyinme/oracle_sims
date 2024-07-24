#!/bin/bash

#SBATCH --job-name=waves_vof
#SBATCH --account=oracle
#SBATCH --nodes=1
#SBATCH --time=2:00:00
#SBATCH --output=out.%x_%j
##SBATCH --qos=high
##SBATCH --switches=2

source /home/lmartine/.bash_profile 
export EXAWIND_MANAGER=${HOME}/exawind-manager
source ${EXAWIND_MANAGER}/start.sh
spack-start

quick-activate /projects/oracle/tony/amr-wind-env-jul-2024
#quick-activate /projects/wakedynamics/tony/amr-wind-mar_2024
spack load amr-wind #@main

#ranks_per_node=36
#mpi_ranks=$(expr $SLURM_JOB_NUM_NODES \* $ranks_per_node)
#export OMP_NUM_THREADS=1  # Max hardware threads = 4
#export OMP_PLACES=threads
#export OMP_PROC_BIND=spread



# From Jon
#PPN=96
#RANKS=$((${SLURM_JOB_NUM_NODES}*${PPN}))
#module load PrgEnv-intel/8.5.0
#module load libfabric/1.15.2.0
#module load cray-libsci/23.12.5
#module load intel/2023.2.0
#module load craype-network-ofi
#module load craype-x86-spr
#module load cray-mpich/8.1.28
##export EXAWIND_MANAGER=/scratch/${USER}/exawind-manager
##cd ${EXAWIND_MANAGER} && source shortcut.sh && cd -
##spack env activate exawind-kestrel
##spack load amr-wind
#quick-activate /projects/wakedynamics/tony/amr-wind-mar_2024
#spack load amr-wind
#ONEAPI_PATH=$(spack location -i intel-oneapi-runtime) # Crucial for enabling the stall
#export LD_LIBRARY_PATH=${ONEAPI_PATH}/lib:${LD_LIBRARY_PATH} # Crucial for enabling the stall
#export LD_PRELOAD=/nopt/nrel/apps/cray-mpich-stall/libs_mpich_nrel_intel/libmpi_intel.so.12 # Crucial for enabling the stall
#export MPICH_OFI_CQ_STALL=1 # Crucial for enabling the stall
#export MPICH_OFI_CQ_STALL_USECS=16 # Crucial for enabling the stall

#srun -N${SLURM_JOB_NUM_NODES} -n${RANKS} --ntasks-per-node=${PPN} --distribution=cyclic:cyclic --cpu_bind=cores amr_wind abl_multiphase_laminar.inp








#echo "Job name       = $SLURM_JOB_NAME"
#echo "Num. nodes     = $SLURM_JOB_NUM_NODES"
#echo "Num. MPI Ranks = $mpi_ranks"
#echo "Num. threads   = $OMP_NUM_THREADS"
#echo "Working dir    = $PWD"

rm -rf post_processing

#srun -n 832  -c 1 --cpu_bind=cores amr_wind abl_multiphase_laminar.inp # > out.log 2>&1
#srun -n 1024  -c 1 --cpu_bind=cores amr_wind abl_multiphase_laminar.inp # > out.log 2>&1
srun -n 96  -c 1 --cpu_bind=cores amr_wind abl_multiphase_laminar.inp # > out.log 2>&1
