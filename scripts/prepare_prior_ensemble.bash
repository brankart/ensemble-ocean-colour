#!/bin/bash
#SBATCH --job-name=prepprior
#SBATCH -e sbatch_output.e%j
#SBATCH -o sbatch_output.o%j
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00            # Temps d’exécution maximum demande (HH:MM:SS)
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
###SBATCH --qos=qos_cpu-t3
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

odir="ENS${ens_size}.nc.bas"

rm -fr ${odir} ; mkdir ${odir}

# Loop on ensemble members
let omember=1
let imember=${ens_mem1}
while [ $omember -le ${ens_size} ] ; do
  imembertag3=`echo $imember | awk '{printf("%03d", $1)}'`
  omembertag4=`echo $omember | awk '{printf("%04d", $1)}'`


  # Loop on NEMO file types
  let filetypeidx=1
  for filetype in ${list_filetypes} ; do

    # Empty depth extraction command for 2D files
    if [ $filetype = "diag" ] ; then
      listdim="--mk_rec_dmn time_counter -d x,${imin},${imax} -d y,${jmin},${jmax}"
      listvar="-v nav_lat,nav_lon,time_counter,${list_variables[$filetypeidx]}"
    else
      listdim="-d x,${imin},${imax} -d y,${jmin},${jmax} -d deptht,${kmin},${kmax}"
      listvar="-v nav_lat,nav_lon,deptht,time_counter,${list_variables[$filetypeidx]}"
    fi

    # Loop on simulation periods (stored in separate files)
    for period in ${list_periods} ; do

      echo "Extracting member: $omember, filetype: $filetype period: $period"
      ifile="${priordir}/${imembertag3}${simulation_name}_${period}_${filetype}_${region_name}.nc"
      ofile="m${omembertag4}_${filetype}_${period}.nc"

      rm -f $ofile
      ncks ${listdim} ${listvar} ${ifile} ${ofile}

    done

    # Merge all time period in one single file
    rm -f tmp_merged.nc
    ncrcat m${omembertag4}_${filetype}_*.nc tmp_merged.nc
    rm -f m${omembertag4}_${filetype}_*.nc

    # Extract required time period and adjust time variable
    ofile="${odir}/vct_${filetype}_${omembertag4}.nc"
    ncks -F -d time_counter,${tmin},${tmax} tmp_merged.nc tmp_merged2.nc # extract required period
    rm -f tmp_merged.nc
    ncap2 -O -s "time_counter=time_counter/86400-${refday}" tmp_merged2.nc tmp_merged.nc
    rm -f tmp_merged2.nc
    ncatted -O -a units,time_counter,o,c,'days since 1950-01-01 00:00:00' tmp_merged.nc
    mv tmp_merged.nc ${ofile}

    let filetypeidx=${filetypeidx}+1
  done

  let imember=$imember+1
  let omember=$omember+1
done

