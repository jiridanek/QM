#!/usr/bin/env bash

for d in ../02_*/*/; do
	n=`basename "$d"`
	mkdir "$n"
	cat > "${n}/${n}.com" <<EOF
# PM3 Freq NoSymm

${n}

0 1
EOF
	tail -n +3 ${d%%/}/${n}_last.xyz >> "${n}/${n}.com"
	echo -e "\n" >> "${n}/${n}.com"
done