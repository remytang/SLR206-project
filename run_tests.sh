#!/bin/bash

dir=.
output=${dir}/output
bin=${bin}/bin
java=java

threads="1 4 6 8 10 12"
sizes="100 1000 10000"
writes="0 10 100" # update ratios
duration="2000"
warmup="0"

CP=bin
MAINCLASS=contention.benchmark.Test

if [ ! -d "${output}" ]; then
  mkdir $output
fi
if [ ! -d "${output}/log" ]; then
#  rm -rf ${output}/log
  mkdir ${output}/log
fi

benchs="linkedlists.lockbased.CoarseGrainedListBasedSet linkedlists.lockbased.HandOverHandListBasedSet linkedlists.lockbased.LazyLinkedListSortedSet"

for bench in ${benchs}; do
  for write in ${writes}; do
    for t in ${threads}; do
       for i in ${sizes}; do
         r=$((2*${i})) #list range twice as big as the list size
         out=${output}/log/${bench}-i${i}-u${write}-t${t}-w${warmup}-d${duration}.log
         echo "${java} -cp ${CP} ${MAINCLASS} -W ${warmup} -u ${write} -d ${duration} -t ${t} -i ${i} -r ${r} -b ${bench}"
         ${java} -cp ${CP} ${MAINCLASS} -W ${warmup} -u ${write} -d ${duration} -t ${t} -i ${i} -r ${r} -b ${bench} 2>&1 > ${out}
       done
    done
  done
done
