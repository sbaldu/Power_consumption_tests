#!/bin/bash

if [[ $1 == "-h" || $1 == "--help" ]]; then
  echo "Usage: $0 <gpus> <threads_per_gpu>"
  exit 1
fi
if [ $# -ne 2 ]; then
  echo "Usage: $0 <gpus> <threads_per_gpu>"
  exit 1
fi

gpus=$1
threads_per_gpu=$2

# launch the program in background
for (i = 0; i < $gpus; ++i)
do
  (CUDA_VISIBLE_DEVICES=$i \
	taskset -c $(( $i * $threads_per_gpu ))-$(( $(($i + 1)) * $threads_per_gpu )) \
	./alpaka --cuda --runForMinutes 2 --numberOfThreads $threads_per_gpu) &
done

# while the program runs in the background, we can measure the energy consumption
# we read the energy values from the GPUs every 5 seconds, so to not affect the performance
time=5
for (gpu_id = 0; i < $gpus; ++gpu_id)
do
  nvidia-smi dmon -i $gpu_id -d $time
done
