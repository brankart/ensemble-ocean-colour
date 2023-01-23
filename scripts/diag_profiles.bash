#!/bin/bash
#

. ./param.bash

cd $wdir

updir="${exptdiag}SMPENS${upd_size}.nc.bas"

let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  rm -f tmp_series.nc tmp_depth.nc
  ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d time_counter,$tdiag,$tdiag \
       -v $vdiag ${updir}/vct_${fdiag}_${membertag4}.nc tmp_series.nc

  ncdump -v $vdiag tmp_series.nc | sed -e "1,/$vdiag =/d" -e '$d' > tmpprofile.txt
  paste tmpprofile.txt listdepth.txt > ${figdir}/profile_${exptdiag}_${vdiag}_i${idiag}j${jdiag}t${tdiag}_${membertag4}.txt
  rm -f tmp_series.nc tmp_depth.nc

  let member=$member+1
done

