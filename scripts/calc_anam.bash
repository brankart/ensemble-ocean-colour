#!/bin/bash
#SBATCH --job-name=calcanam
#SBATCH -e sbatch_output.e%j
#SBATCH -o sbatch_output.o%j
#SBATCH --ntasks=40
#SBATCH --time=01:00:00
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

ensdir2="ENS${ens_size}.cpak.bas"
quadir2="QUA0013.cpak.bas"
anadir2="ANAENS${ens_size}.cpak.bas"

rm -fr $anadir2 ; mkdir $anadir2
srun sesam -mode anam -inxbas $ensdir2 -inxbasref $quadir2 \
           -outxbas $anadir2 -typeoper + -fixjpx ${blocksize}

