#!/bin/bash
#

. ./param.bash

cd $wdir

ensdir="ENS${ens_size}.nc.bas"

rm -f tmp_scatterplot_1.txt tmp_scatterplot_2.txt

let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  if [ ${fdiag1} = 'time' ] ; then
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag \
         -v $vdiag1 ${ensdir}/vct_${fdiag1}_${membertag4}.nc tmp_series.nc
  else
    if [ ${fdiag1} = 'diag' ] ; then
      ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d time_counter,$tdiag,$tdiag \
           -v $vdiag1 ${ensdir}/vct_${fdiag1}_${membertag4}.nc tmp_series.nc
    else
      ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag -d time_counter,$tdiag,$tdiag \
           -v $vdiag1 ${ensdir}/vct_${fdiag1}_${membertag4}.nc tmp_series.nc
    fi
  fi

  ncdump -v $vdiag1 tmp_series.nc | sed -e "1,/$vdiag1 =/d" -e '$d' >> tmp_scatterplot_1.txt
  rm -f tmp_series.nc

  if [ ${fdiag1} = 'time' ] ; then
    ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag \
         -v $vdiag2 ${ensdir}/vct_${fdiag2}_${membertag4}.nc tmp_series.nc
  else
    if [ ${fdiag2} = 'diag' ] ; then
      ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d time_counter,$tdiag,$tdiag \
	   -v $vdiag2 ${ensdir}/vct_${fdiag2}_${membertag4}.nc tmp_series.nc
    else
      ncks -d x,$idiag,$idiag -d y,$jdiag,$jdiag -d deptht,$kdiag,$kdiag -d time_counter,$tdiag,$tdiag \
	   -v $vdiag2 ${ensdir}/vct_${fdiag2}_${membertag4}.nc tmp_series.nc
    fi
  fi

  ncdump -v $vdiag2 tmp_series.nc | sed -e "1,/$vdiag2 =/d" -e '$d' >> tmp_scatterplot_2.txt
  rm -f tmp_series.nc


  let member=$member+1
done


paste tmp_scatterplot_1.txt tmp_scatterplot_2.txt | tr ';' ' ' > ${figdir}/prior_${vdiag1}_${vdiag2}_i${idiag}j${jdiag}t${tdiag}.txt
rm -f tmp_scatterplot_1.txt tmp_scatterplot_2.txt

