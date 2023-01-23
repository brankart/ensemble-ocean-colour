#!/bin/bash
#

. ./param.bash

cd $wdir

updir="${exptdiag}SMPENS${upd_size}.nc.bas"

let member=1
while [ $member -le ${upd_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  if [ ${fdiag} = 'diag' ] ; then
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag \
	  -v $vdiag ${updir}/vct_${fdiag}_${membertag4}.nc tmp_series.nc
  else
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag \
	  -v $vdiag ${updir}/vct_${fdiag}_${membertag4}.nc tmp_series.nc
  fi

  ncdump -v $vdiag tmp_series.nc | sed -e "1,/$vdiag =/d" -e '$d' > ${figdir}/${exptdiag}_${vdiag}_i${idiag}j${jdiag}_${membertag4}.txt
  rm -f tmp_series.nc

  let member=$member+1
done

