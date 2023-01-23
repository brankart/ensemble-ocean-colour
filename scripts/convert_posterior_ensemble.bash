#!/bin/bash
#SBATCH --job-name=convert
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

updir2="${expt}SMPENS${upd_size}.cpak.bas"
updir="${expt}SMPENS${upd_size}.nc.bas"

rm -fr $updir ; mkdir $updir
sesam -mode intf -inxbas $updir2 -outxbas $updir

