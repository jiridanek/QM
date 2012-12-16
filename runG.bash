#!/usr/bin/env bash

module add gaussian:03.E1

for m in */*.com; do
	d=`dirname "$m"`
	b=`basename "$m" .com`
	pushd "$d"
	g03 "$b"
	popd	
done
