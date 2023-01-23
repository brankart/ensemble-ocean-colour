#!/bin/bash

. ./param.bash

cd $wdir

cat > domain_localization.cfg <<EOF
1 1 0 1
${loc_cut_space} ${loc_cut_space}  0 ${loc_cut_time}
${loc_efd_space} ${loc_efd_space} ${loc_efd_space} ${loc_efd_time}
end
EOF

rm -f zone_spat.czon part_spat.cpak
sesam -mode zone -incfg domain_localization.cfg -outpartvar part_spat.cpak -outzon zone_spat.czon

