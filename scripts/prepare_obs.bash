#!/bin/bash
#SBATCH --job-name=prepobs
#SBATCH -e sbatch_output.e%j
#SBATCH -o sbatch_output.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:55:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

if [ ! -d Obs_${obs_scenario} ] ; then
  mkdir Obs_${obs_scenario}
fi

obsname="Obs_${obs_scenario}/obs"
dbsfile="obs${data_var}_${data_scenario}.ncdbs"

# Prepare sesamlist with time bounds for extracting partial observations
cp sesamlist sesamlist_obs
if [ $jday_last != "none" ] ; then
  echo "OBS_TIM_MAX-1:1=$jday_last" >> sesamlist_obs
fi
if [ $jday_first != "none" ] ; then
  echo "OBS_TIM_MIN-1:1=$jday_first" >> sesamlist_obs
fi

# Generate observation file
rm -f ${obsname}${data_var}.cobs
sesam -mode obsv -indbs ${dbsfile} -outobs ${obsname}#.cobs -affectobs ${data_var} -config sesamlist_obs

# Generate observation error std ratio file
rm -f ${obsname}_oestdr_${data_var}.cobs
sesam -mode oper -inobs ${obsname}#.cobs -outobs ${obsname}_oestdr_#.cobs \
                 -configobs ${obsname}#.cobs -typeoper cst_$oestdr

# Generate observation error std file
rm -f ${obsname}_oestd_${data_var}.cobs
sesam -mode oper -inobs ${obsname}#.cobs -inobsref ${obsname}_oestdr_#.cobs -outobs ${obsname}_oestd_#.cobs \
                 -configobs ${obsname}#.cobs -typeoper x

rm -f sesamlist_obs
