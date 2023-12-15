#!/bin/bash

# display help messages
if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "Usage: $0 <min_core> <max_core> <sep>"
	exit 1
fi
# check if the number of arguments is correct
if [ $# -ne 3 ]; then
	echo "Usage: $0 <min_core> <max_core> <sep>"
	exit 1
fi

min_core=$1
max_core=$2
sep=$3

# this script is used to measure the CPU throughput and energy consumption of the system.
for ((i = $min_core; i <= $max_core; i = $i+$sep))
do
  echo "Running with $cores cores"
  likwid-perfctr -f -C S0:$cores -g ENERGY -t 1s -O -o $cores.csv \
	./alpaka --serial --runForMinutes 3 --numberOfThreads $cores
done
