#!/bin/bash

dir=.
output=${dir}/output
bin=${bin}/bin
java=java
filename=_data.csv
threads="1 4 6 8 10 12"
sizes="100 1000 10000"
writes="0 10 100" # update ratios
duration="2000"
warmup="0"

if [ ! -d "${output}" ]; then
  mkdir $output
fi
if [ ! -d "${output}/data" ]; then
  mkdir ${output}/data
fi

benchs="linkedlists.lockbased.CoarseGrainedListBasedSet linkedlists.lockbased.HandOverHandListBasedSet linkedlists.lockbased.LazyLinkedListSortedSet"
for bench in ${benchs}; do
  dest=$(${output}/data/${bench:22}_${filename})
  touch ${dest}
  echo "throughput,threads,uratio,lsize" > ${dest}
  for write in ${writes}; do
    for t in ${threads}; do
       for i in ${sizes}; do
         grep Throughput ${dir}/${output}/cleaned_log/${bench}-i${i}-u${write}-t${t}-w${warmup}-d${duration}.log | awk -v ORS="," '{print $3}' >> ${dest}
         echo -n ${t} >> ${dest}
         echo -n ',' >> ${dest}
         echo -n ${write} >> ${dest}
         echo -n ',' >> ${dest}
         echo ${i} >> ${dest}
       done
    done
  done
done
