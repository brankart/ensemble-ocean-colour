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

updir="${exptdiag}SMPENS${upd_size}.nc.bas"
quadir="${exptdiag}QUA0005.nc.bas"
quadir2="${exptdiag}QUA0005.cpak.bas"

cp -pr $quadir2/perc* $quadir

sesam -mode anam -inxbas $updir -outxbasref $quadir -config sesamlist_phenology

