#!/bin/bash
#

. ./param.bash

cd $wdir

ensdir="ENS${ens_size}.nc.bas"

let member=1
while [ $member -le ${ens_size} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  rm -f tmpfile_i.nc
  ln -sf ${ensdir}/vct_ptrc_${membertag4}.nc tmpfile_i.nc
  rm -f tmpfile_o.nc
  diag_phenology.x
  ncks -A -v nav_lon,nav_lat,deptht tmpfile_i.nc tmpfile_o.nc
  mv tmpfile_o.nc ${ensdir}/vct_time_${membertag4}.nc
  rm -f tmpfile_i.nc

  let member=$member+1
done

