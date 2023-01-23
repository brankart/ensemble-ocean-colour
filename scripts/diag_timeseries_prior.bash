#!/bin/bash
#

. ./param.bash

cd $wdir

ensdir="ENS${ens_size}.nc.bas"

let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  if [ ${fdiag} = 'diag' ] ; then
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag \
          -v $vdiag ${ensdir}/vct_${fdiag}_${membertag4}.nc tmp_series.nc
  else
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag \
	  -v $vdiag ${ensdir}/vct_${fdiag}_${membertag4}.nc tmp_series.nc
  fi

  ncdump -v $vdiag tmp_series.nc | sed -e "1,/$vdiag =/d" -e '$d' > ${figdir}/prior_${vdiag}_i${idiag}j${jdiag}_${membertag4}.txt
  rm -f tmp_series.nc

  let member=$member+1
done

