#!/bin/bash

. ./param.bash

cd $wdir

updir2="${exptdiag}SMPENS${upd_size}.cpak.bas"
tmpdir2="TMP_LOG${upd_size}.cpak.bas"

# Compute log of ensemble members

rm -fr $tmpdir2 ; mkdir $tmpdir2

let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  sesam -mode oper -invar ${updir2}/vct${membertag4}.cpak \
                   -outvar ${tmpdir2}/vct${membertag4}.cpak -typeoper log

  let member=$member+1
done

# Compute ensemble standard deviation of log

echo "${upd_size}" > listfile.cfg
let imember=1
while [ $imember -le ${upd_size} ] ; do
  imembertag4=`echo $imember | awk '{printf("%04d", $1)}'`
  echo "${tmpdir2}/vct${imembertag4}.cpak" >> listfile.cfg
  let imember=$imember+1
done

rm -f ${exptdiag}_logstd*.nc
sesam -mode oper -outvar ${exptdiag}_logstd#.nc -incfg listfile.cfg -typeoper std

rm -fr ${tmpdir2}
rm -f listfile.cfg
