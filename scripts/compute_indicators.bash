#!/bin/bash
#SBATCH --job-name=indicators
#SBATCH -e sbatch_output.e%j
#SBATCH -o sbatch_output.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
###SBATCH --qos=qos_cpu-t3
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

cd $indicators_dir

module load python
conda activate PISCES-DIAG

# Loop on ensemble members
let omember=1
let imember=${ens_mem1}
while [ $omember -le ${ens_size} ] ; do
  imembertag3=`echo $imember | awk '{printf("%03d", $1)}'`

  # Loop on simulation periods (stored in separate files)
  for period in ${list_periods} ; do

    rm -fr tmpdata ; mkdir tmpdata

    # Get NEMO data files
    cd tmpdata
    ln -s ${priordir}/${imembertag3}${simulation_name}_${period}_ptrc_${region_name}.nc .
    ln -s ${priordir}/${imembertag3}${simulation_name}_${period}_diad_${region_name}.nc .
    cd ..

    # Get compute indicators
    python diag.py --dir tmpdata/

    # Save indicators
    mv tmpdata/${imembertag3}${simulation_name}_${period}_diag_${region_name}.nc ${priordir}

  done

  let imember=$imember+1
  let omember=$omember+1
done

rm -fr tmpdata
