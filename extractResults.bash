#!/usr/bin/env bash

module add qmutil

for m in */*.com; do
	d=`dirname "$m"`
	b=`basename "$m" .com`
	pushd "$d"
	extract-gopt-ene "${b}.log"
	extract-gopt-xyz "${b}.log" > "${b}_opt.xyz"
	extract-xyz-str "${b}_opt.xyz" last > "${b}_last.xyz"
	popd
done

