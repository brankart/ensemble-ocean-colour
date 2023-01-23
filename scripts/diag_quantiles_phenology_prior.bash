#!/bin/bash
#SBATCH --job-name=calcquan
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

ensdir="ENS${ens_size}.nc.bas"
quadir="priorQUA0005.nc.bas"
quadir2="priorQUA0005.cpak.bas"

cp -pr $quadir2/perc* $quadir

sesam -mode anam -inxbas $ensdir -outxbasref $quadir -config sesamlist_phenology

