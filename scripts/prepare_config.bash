#!/bin/bash

. ./param.bash

cd $wdir

ensdir="ENS${ens_size}.nc.bas"

# Get sesamlist
cp -p ${sdir}/sesamlist* .

# Mask file
for filetype in ${list_filetypes} ; do
  cp -f ${ensdir}/vct_${filetype}_0001.nc mask_${filetype}_.nc
done

# Zero file
rm -f zero.cpak
sesam -mode oper -invar mask#.nc -outvar zero.cpak -typeoper cst_0.0

# One file
rm -f one.cpak
sesam -mode oper -invar mask#.nc -outvar one.cpak -typeoper cst_1.0

