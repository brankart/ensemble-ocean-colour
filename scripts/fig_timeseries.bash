#/bin/bash
#

. ./param.bash

cd $figdir

module load gnuplot

# Define list of timesries to plot

list=""

let member=1
while [ $member -le ${ntseries} ] ; do
  membertag4=`echo $member | awk '{printf("%04d", $1)}'`

  let lsidx=1
  for expt in $ltseries ; do
    list="$list  \"${expt}_${vdiag}_i${idiag}j${jdiag}_${membertag4}.txt\" u 1 w l ls ${lsidx},"
    let lsidx=$lsidx+1
  done

  let member=$member+1
done

# Prepare gnuplot script

cat <<EOF > graphe.gp
#!/usr/bin/gnuplot
#
set term postscript eps color enhanced
set output 'tmp.ps'
set size 1,0.7
set tmargin 2
set bmargin 3
set lmargin 8
set rmargin 3
set xtics font 'arial bold,32'
set xtics offset 0,-1,0
set xtics (30,60,90)
set xrange [1:60]
set ytics font 'arial bold,32'
set yrange [0:2.5]
unset key
set style line 1 lc rgb "black" lw 1 lt 1
set style line 2 lc rgb "blue" lw 1 lt 1
set style line 3 lc rgb "red" lw 1 lt 1
set style line 4 lc rgb "green" lw 1 lt 1
plot [1:92] $list
exit
EOF

# Make the plot

gnuplot < graphe.gp
convert -density 200 tmp.ps timeseries_${exptdiag}_${vdiag}_i${idiag}j${jdiag}.jpg
rm -f graphe.gp tmp.ps

