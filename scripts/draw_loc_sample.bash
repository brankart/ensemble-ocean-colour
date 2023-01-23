#!/bin/bash
#SBATCH --job-name=drawsample
#SBATCH -e drawsample.e%j
#SBATCH -o drawsample.o%j
#SBATCH --ntasks=480
#SBATCH --ntasks-per-node=40
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

odirbas="LOCENS${ens_size}.cpak.bas"
odirbastag="LOCENS${ens_size}-${loc_dir_tag}.cpak.bas"

# Prepare sesamlist with localization scales
cp sesamlist sesamlist_loc
echo "LOC_TIME_SCALE=$loc_time_scale" >> sesamlist_loc
echo "LOC_RADIUS_IN_DEG=$loc_radius"  >> sesamlist_loc
echo "SPCT_FIRST_ONLY=.TRUE."  >> sesamlist_loc

#srun sesam -mode spct -invar zero.cpak -outvar zran#.nc -typeoper R_${loc_lmax} -config sesamlist_loc

# Sample random fields with required spectrum
rm -fr ${odirbas} ; mkdir ${odirbas}
srun sesam -mode spct -inxbas ${odirbas} -outxbas ${odirbas} -typeoper R_${loc_lmax} -config sesamlist_loc

rm -fr ${odirbastag}
mv ${odirbas} ${odirbastag}
ln -sf ${odirbastag} ${odirbas}

rm -f sesamlist_loc
