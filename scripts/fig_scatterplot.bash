#/bin/bash
#

. ./param.bash

cd $figdir

module load gnuplot

# Define list of scatterplot

list=""

let lsidx=1
for expt in $lsplot ; do
  list="$list  \"${expt}_${vdiag1}_${vdiag2}_i${idiag}j${jdiag}t${tdiag}.txt\" u 1:2 w p ls ${lsidx},"
  let lsidx=$lsidx+1
done

# Prepare gnuplot script

cat <<EOF > graphe.gp
#!/usr/bin/gnuplot
#
set term postscript eps color enhanced
set output 'tmp.ps'
set size 1,1.3
set tmargin 2
set bmargin 3
set lmargin 8
set rmargin 3
set xtics offset 0,-1,0
set xtics font 'arial bold,32'
set xrange [0:2.5]
set ytics font 'arial bold,32'
set yrange [0:700]
unset key
set style line 1 lc rgb "black" lw 1 lt 1
set style line 2 lc rgb "blue" lw 1 lt 1
set style line 3 lc rgb "red" lw 1 lt 1
set style line 4 lc rgb "green" lw 1 lt 1
plot $list
exit
EOF

# Make the plot

gnuplot < graphe.gp
convert -density 200 tmp.ps scatterplot_${exptdiag}_${vdiag1}_${vdiag2}_i${idiag}j${jdiag}t${tdiag}.jpg
rm -f graphe.gp tmp.ps

