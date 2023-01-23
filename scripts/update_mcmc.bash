#!/bin/bash
#SBATCH --job-name=mcmcsampler
#SBATCH -e mcmcsampler.e%j
#SBATCH -o mcmcsampler.o%j
#SBATCH --ntasks=640
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

# Update sesamlist with MCMC parameters
cp sesamlist sesamlist_mcmc
echo "MCMC_SCALE_MULTIPLICITY-1=${scal_mult_1}" >> sesamlist_mcmc
echo "MCMC_SCALE_MULTIPLICITY-2=${scal_mult_2}" >> sesamlist_mcmc
echo "MCMC_CONTROL_PRINT=1000" >> sesamlist_mcmc
echo "MCMC_CONVERGENCE_CHECK=1000" >> sesamlist_mcmc
echo "OBSERROR_CDF=${obserror_type}" >> sesamlist_mcmc
echo "OESTD_INFLATION=${oestd_inflation}" >> sesamlist_mcmc

# Observation to use
obsname="Obs_${scenario_used}/obs"

# Directory settings
diranam="QUA0013.cobs.bas"

idir1="ANAENS${ens_size}.cpak.bas"
idir2="LOCENS${ens_size}.cpak.bas"
idir1obs="ANAENS${ens_size}.cobs.bas"
idir2obs="LOCENS${ens_size}.cobs.bas"

odir="${expt}SMPANAENS${upd_size}.cpak.bas"
odirobs="${expt}SMPANAENS${upd_size}.cobs.bas"

ln -sf $idir1 ANA1_ENS${ens_size}.cpak.bas
ln -sf $idir2 ANA2_ENS${ens_size}.cpak.bas
ln -sf $idir1obs ANA1_ENS${ens_size}.cobs.bas
ln -sf $idir2obs ANA2_ENS${ens_size}.cobs.bas

rm -fr ${odir} ; mkdir ${odir}
rm -fr ${odirobs} ; mkdir ${odirobs}

cp $sdir/param.bash $odir

srun sesam -mode mcmc -inxbas ANA@_ENS${ens_size}.cpak.bas -outxbas ${odir} -iterate $niter \
           -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs -oestd ${obsname}_${oestdfile}_#.cobs \
           -inobas ANA@_ENS${ens_size}.cobs.bas -outobas ${odirobs} -obsanam ${diranam} -config sesamlist_mcmc

rm ANA1_ENS${ens_size}.cpak.bas ANA2_ENS${ens_size}.cpak.bas
rm ANA1_ENS${ens_size}.cobs.bas ANA2_ENS${ens_size}.cobs.bas

rm -f sesamlist_mcmc
