#!/usr/bin/env bash

for i in $(ls *.tar.gz); do
	printf "\nCreating directory ${i%%.*}...\n\n"
	mkdir ${i%%.*}
	printf "\nDecompressing tarball $i \ninto directory ${i%%.*}\n\n"
	tar -xvf $i -C ${i%%.*}
done


