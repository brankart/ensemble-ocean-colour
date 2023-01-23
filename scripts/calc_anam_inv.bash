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

quadir2="QUA0013.cpak.bas"
upanadir2="${expt}SMPANAENS${upd_size}.cpak.bas"
updir2="${expt}SMPENS${upd_size}.cpak.bas"

rm -fr $updir2 ; mkdir $updir2
sesam -mode anam -inxbas $upanadir2 -inxbasref $quadir2 \
                 -outxbas $updir2 -typeoper - -fixjpx ${blocksize}

