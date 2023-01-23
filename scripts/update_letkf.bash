#!/bin/bash
#SBATCH --job-name=letkf
#SBATCH -e letkf.e%j
#SBATCH -o letkf.o%j
###SBATCH --ntasks=640
#SBATCH --ntasks=160
#SBATCH --ntasks-per-node=40
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

# Observation to use
obsname="Obs_${scenario_used}/obs"

# Directory settings
anadir="ANAENS${ens_size}.cpak.bas"
upanadir="${expt}SMPANAENS${ens_size}.cpak.bas"

#ls -l ${obsname}_ana_*.cobs
#ls -l ${obsname}_anaoestd_*.cobs

#sesam -help config -configobs ${obsname}_ana_#.cobs

rm -fr ${upanadir} ; mkdir ${upanadir}
srun sesam -mode lroa -inxbas ${anadir} -outxbas ${upanadir} \
                 -invarref zero.cpak -outvar tmpxa.cpak \
                 -inobs ${obsname}_ana_#.cobs \
                 -configobs ${obsname}_ana_#.cobs \
                 -oestd ${obsname}_anaoestd_#.cobs \
                 -inpartvar part_spat.cpak -inzon zone_spat.czon \
		 -disable 'TTTFT' -fixjpx ${blocksize}
rm -f tmpxa.cpak
