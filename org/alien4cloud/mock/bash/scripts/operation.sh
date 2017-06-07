#!/bin/bash -e

# TODO use ${log_length} to limit or maximise log size
/bin/more ${data}

min_sleep=$[$sleep_time / 2]
max_sleep=$[$min_sleep + $sleep_time]
random_sleep_time=$[($RANDOM % ($[$max_sleep - $min_sleep] + 1)) + $min_sleep]
random_sleep_time=$[$random_sleep_time * sleep_factor]

/bin/sleep $random_sleep_time