#!/bin/bash
#SBATCH --time=01:00:00           # Walltime in hh:mm:ss
#SBATCH --nodes=1               # Number of nodes
#SBATCH --exclusive
#SBATCH --job-name=scorep
#SBATCH --partition=g100_usr_dbg
#SBATCH --cpus-per-task=1

module purge
source modules.sh
module list

make

pool=( 1 2 5 10 20 40 )

for i in "${pool[@]}"
do
        srun --cpu-bind=cores --cpus-per-task=$SLURM_CPUS_PER_TASK -n $i exe 10 1000
	echo "done"
	wait
done

