#!/bin/bash

# Get number of days in a year
# ----------------------------
#
function get_daysinyear {

   gdy_year=$1

   leap_year=$( echo "scale=0;${gdy_year}%4" | bc -l )

   if [ ${leap_year} -eq 0 ] ; then
      daysinyear='366'
   else
      daysinyear='365'
   fi

}

# Get number of days in a month
# -----------------------------
#
function get_daysinmonth {

   gdm_month=$1
   gdm_year=$2

   leap_year=$( echo "scale=0;${gdm_year}%4" | bc -l )

   case ${gdm_month} in
    01 ) daysinmonth=31 ;;
    02 ) daysinmonth=28 ;;
    03 ) daysinmonth=31 ;;
    04 ) daysinmonth=30 ;;
    05 ) daysinmonth=31 ;;
    06 ) daysinmonth=30 ;;
    07 ) daysinmonth=31 ;;
    08 ) daysinmonth=31 ;;
    09 ) daysinmonth=30 ;;
    10 ) daysinmonth=31 ;;
    11 ) daysinmonth=30 ;;
    12 ) daysinmonth=31 ;;
   esac

   if [ ${gdm_month} = '2' ] ; then
      if [ ${leap_year} -eq 0 ] ; then
         daysinmonth=29
      fi
   fi

}

# Convert Julian day to date
# --------------------------
#
function jday2date {

   ts_jday=$1

   let ts_year=1950
   let ts_month=1
   let ts_day=1
   let ts_jday0=-1

   while [ $ts_jday0 -lt $ts_jday ]
   do
     get_daysinyear $ts_year
     let ts_year=$ts_year+1
     let ts_jday0=$ts_jday0+$daysinyear
   done
   let ts_year=$ts_year-1
   let ts_jday0=$ts_jday0-$daysinyear

   ts_dayinyear=$( echo "$ts_jday - $ts_jday0" | bc -l )

   while [ $ts_jday0 -lt $ts_jday ]
   do
     get_daysinmonth $ts_month $ts_year
     let ts_month=$ts_month+1
     let ts_jday0=$ts_jday0+$daysinmonth
   done
   let ts_month=$ts_month-1
   let ts_jday0=$ts_jday0-$daysinmonth

   ts_day=$( echo "$ts_jday - $ts_jday0" | bc -l )

   ts_day=`echo $ts_day | awk '{printf("%02d", $1)}'`
   ts_month=`echo $ts_month | awk '{printf("%02d", $1)}'`
   ts_year=`echo $ts_year | awk '{printf("%04d", $1)}'`

   ts_date="y${ts_year}m${ts_month}d${ts_day}"

}

