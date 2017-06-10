#!/bin/bash -e

# TODO use ${log_length} to limit or maximise log size
/bin/more ${data}

sleep_time=$(( weight * duration / 100 ))
if [ $sleep_time -lt 3 ]
then
  echo "Can not manager Sleep Time < 3"
  sleep_time=3
fi
echo "Sleep Time: ${sleep_time} sec"

variation_in_sec=$(( variation * sleep_time / 100 ))
if [ $variation_in_sec -lt 1 ]
then
  variation_in_sec=1
fi
echo "Variation is ${variation_in_sec} sec"
min_sleep=$(( sleep_time - variation_in_sec ))

echo "Minimum sleep time is ${min_sleep}"

randomized_variation=$(( variation_in_sec * 2 ))
echo "Randomized variation is ${randomized_variation} sec"

sleep_time=$[($RANDOM % $randomized_variation) + $min_sleep]

echo "Will sleep ${sleep_time}"

/bin/sleep $sleep_time
