#!/bin/bash

. ./param.bash

cd $wdir

# Size of observation sample
smpsize="0200"

# Update sesamlist with LETKF parameters
cp sesamlist sesamlist_letkf
echo "OBSERROR_CDF=${obserror_type}" >> sesamlist_letkf

# Name of observation to transform
obsname="Obs_${scenario_used}/obs"

# Directory settings
ensdir2="ENS${ens_size}.cpak.bas"
quadir2="QUA0013.cpak.bas"
tmpdir2="TMP_SMP${smpsize}.cobs.bas"

# Define quantiles in output directory
rm -fr ${tmpdir2} ; mkdir ${tmpdir2}
echo "13" > ${tmpdir2}/percnbr
cp ${quadir2}/percdef ${tmpdir2}
cp ${quadir2}/percref ${tmpdir2}

# Compute sample of transformed observation
sesam -mode anam -inobs ${obsname}#.cobs -configobs ${obsname}#.cobs \
	         -oestd ${obsname}_oestdr_#.cobs \
	         -inobas ${ensdir2} -outobas ${tmpdir2} \
		 -config sesamlist_letkf

# Compute ensemble mean and standard deviation
echo "$smpsize" > listfile.cfg
let imember=1
while [ $imember -le $smpsize ] ; do
  imembertag4=`echo $imember | awk '{printf("%04d", $1)}'`
  echo "${tmpdir2}/vct#${imembertag4}.cobs" >> listfile.cfg
  let imember=$imember+1
done

rm -f ${obsname}_ana_CHL.cobs
sesam -mode oper -outobs ${obsname}_ana_#.cobs -incfg listfile.cfg \
                 -configobs ${obsname}#.cobs -typeoper mean

rm -f tmp_anaoestd_CHL.cobs
sesam -mode oper -outobs tmp_anaoestd_#.cobs -incfg listfile.cfg \
                 -configobs ${obsname}#.cobs -typeoper std

rm -f ${obsname}_anaoestd_CHL.cobs
sesam -mode oper -inobs tmp_anaoestd_#.cobs -outobs ${obsname}_anaoestd_#.cobs \
                 -configobs ${obsname}#.cobs -typeoper max_${minoestd}
rm -f tmp_anaoestd_CHL.cobs

rm -fr ${tmpdir2}
rm -f listfile.cfg sesamlist_letkf
