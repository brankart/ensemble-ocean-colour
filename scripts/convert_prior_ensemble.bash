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

ensdir="ENS${ens_size}.nc.bas"
ensdir2="ENS${ens_size}.cpak.bas"

rm -fr $ensdir2 ; mkdir $ensdir2
sesam -mode intf -inxbas $ensdir -outxbas $ensdir2

