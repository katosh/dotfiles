#!/bin/bash

mynetstatfile=/run/user/$(id -u)/mynetstat
( cat $mynetstatfile 2> /dev/null | tr '\n' ' ' ;
  ( grep 'bond0:' /proc/net/dev |
    awk '{sumIn += $2; sumOut += $10;} END {printf "%d %d ",sumIn,sumOut}';
    date +%s%N ) |
        tee $mynetstatfile ) |
        awk '{
              diff = ($6 - $3)/1e9;
              ind = ($4 - $1)/diff;
              outd = ($5 - $2)/diff;
              printf "%f\n%f",ind,outd;
          }' | numfmt --to=iec | awk '{printf "%sB/s ",$0}'

mytempfile=/run/user/$(id -u)/mycputimes
( cat $mytempfile 2> /dev/null |
    tr -d '\n'; grep 'cpu ' /proc/stat |
    tee $mytempfile ) | \
    awk '{
        usage = (($12-$2)+($14-$4))*100 / (($12-$2)+($14-$4)+($15-$5));
        printf "%.1f% ",usage
    }'

head -n3 /proc/meminfo | tr -d '\n' | awk '{printf "%.1f%",100*($2-$6)/$2}'
