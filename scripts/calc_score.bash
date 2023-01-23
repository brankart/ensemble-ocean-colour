#!/bin/bash

. ./param.bash

cd $wdir

obsname="Obs_${scenario_verif}/obs"

updir2="${exptdiag}SMPENS${upd_size}.cpak.bas"
tmpdir2="TMP_PERT${upd_size}.cobs.bas"

# Perturbation ensemble members with observation error

rm -fr $tmpdir2 ; mkdir $tmpdir2

let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  sesam -mode oper -inobsref ${updir2}/vct${membertag4}.cpak \
                   -inobs ${obsname}_${oestdfile}_#.cobs \
	           -outobs  ${tmpdir2}/vct#${membertag4}.cobs \
                   -configobs ${obsname}#.cobs -typeoper ${obserror_type}

  let member=$member+1
done

# Compute score with perturbed ensemble
sesam -mode scor -inobas $tmpdir2 -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs \
                 -typeoper crps -inpartvar one.cpak > ${exptdiag}_${scenario_verif}_crps.txt

# Compute rank histogram with perturbed ensemble
rm -f tmprank*.cobs
sesam -mode rank -inobasref $tmpdir2 -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs \
	         -outobs tmprank#.cobs > ${exptdiag}_${scenario_verif}_rank.txt
rm -f tmprank*.cobs

rm -fr $tmpdir2
