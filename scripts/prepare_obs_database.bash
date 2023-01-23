#!/bin/bash

. ./param.bash
. ./util.bash

cd $wdir

obsfile="obs${data_var}_${data_scenario}.ncdbs"

for month in ${data_mlist} ; do
  mtag=`echo $month | awk '{printf("%02d", $1)}'`
  idir="$datadir/$mtag"

  get_daysinmonth $month $data_year

  let day=1
  while [ $day -le $daysinmonth ] ; do
    dtag=`echo $day | awk '{printf("%02d", $1)}'`

    ifile="$idir/${data_year}${mtag}${dtag}_d-ACRI-${data_product}-${data_var}-MULTI_4KM-GLO-REP.nc"

    echo "Extracting from $ifile"
    ofile="m${mtag}j${dtag}.nc"

    rm -f $ofile
    ncks --mk_rec_dmn time \
	 -d lon,${data_imin},${data_imax},${data_istp} \
	 -d lat,${data_jmin},${data_jmax},${data_jstp} \
         -v lat,lon,time,${data_var} ${ifile} ${ofile}

    let day=$day+1
  done

done

rm -f $obsfile
ncrcat m*j*.nc $obsfile
rm -f m*j*.nc

ncap2 -O -s "time=time-${data_dayshift}" $obsfile tmp_time.nc
rm -f $obsfile
mv tmp_time.nc $obsfile

# Extract odd days only
if [ ${data_scenario} = "odd" ] ; then
  ncks -d time,1,,2 -v lat,lon,time,${data_var} $obsfile tmp_time.nc
  mv tmp_time.nc $obsfile
fi

# Extract even days only
if [ ${data_scenario} = "even" ] ; then
  ncks -d time,2,,2 -v lat,lon,time,${data_var} $obsfile tmp_time.nc
  mv tmp_time.nc $obsfile
fi
