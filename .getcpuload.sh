#!/bin/bash

mytempfile=/run/user/$(id -u)/mycputimes
echo $( cat $mytempfile 2> /dev/null | tr -d '\n'; grep 'cpu ' /proc/stat | tee $mytempfile ) | \
    awk '{usage=(($12-$2)+($14-$4))*100/(($12-$2)+($14-$4)+($15-$5))} END {printf "%.1f%", usage}'

