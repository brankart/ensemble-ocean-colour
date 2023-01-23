#!/bin/bash
#SBATCH --job-name=calcquan
#SBATCH -e sbatch_output.e%j
#SBATCH -o sbatch_output.o%j
#SBATCH --ntasks=40
#SBATCH --time=01:00:00
#SBATCH --exclusive
#SBATCH -A egi@cpu
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_cpu-dev

. ./param.bash

cd $wdir

updir2="${exptdiag}SMPENS${upd_size}.cpak.bas"
quadir2="${exptdiag}QUA0005.cpak.bas"

cat > percdef <<EOF
0.0
0.2
0.5
0.8
0.9
0.95
1.0
EOF

cat > percref <<EOF
-2.05374891063182
-0.841621233572914
0
0.841621233572914
2.05374891063182
EOF

rm -fr $quadir2 ; mkdir $quadir2
mv percdef percref $quadir2

srun sesam -mode anam -inxbas $updir2 -outxbasref $quadir2 -fixjpx ${blocksize}

