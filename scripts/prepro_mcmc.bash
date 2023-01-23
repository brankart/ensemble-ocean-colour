#!/bin/bash
#

. ./param.bash

cd $wdir

quadir2="QUA0013.cpak.bas"
quadirobs="QUA0013.cobs.bas"
obsname="Obs_${scenario_used}/obs"

rm -fr $quadirobs ; mkdir $quadirobs
cp $quadir2/percdef $quadirobs
cp $quadir2/percref $quadirobs

sesam -mode intf -inobas $quadir2 -outobas $quadirobs -configobs ${obsname}#.cobs

idir1="ANAENS${ens_size}.cpak.bas"
idir2="LOCENS${ens_size}.cpak.bas"
idir1obs="ANAENS${ens_size}.cobs.bas"
idir2obs="LOCENS${ens_size}.cobs.bas"

rm -fr $idir1obs ; mkdir $idir1obs
sesam -mode intf -inobas $idir1 -outobas $idir1obs -configobs ${obsname}#.cobs
rm -fr $idir2obs ; mkdir $idir2obs
sesam -mode intf -inobas $idir2 -outobas $idir2obs -configobs ${obsname}#.cobs

