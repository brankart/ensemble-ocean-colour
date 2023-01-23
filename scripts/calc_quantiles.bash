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

ensdir2="ENS${ens_size}.cpak.bas"
quadir2="QUA0013.cpak.bas"

cat > percdef <<EOF
0.0
0.05
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
0.95
1.0
EOF

cat > percref <<EOF
-2.05374891063182
-1.55477359459685
-1.2815515655446
-0.841621233572914
-0.524400512708041
-0.2533471031358
0
0.2533471031358
0.524400512708041
0.841621233572914
1.2815515655446
1.55477359459685
2.05374891063182
EOF

rm -fr $quadir2 ; mkdir $quadir2
mv percdef percref $quadir2

srun sesam -mode anam -inxbas $ensdir2 -outxbasref $quadir2 -fixjpx ${blocksize}

