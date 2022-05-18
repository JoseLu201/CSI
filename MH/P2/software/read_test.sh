#!/bin/bash

array=( $( ls ./datos_MDD -1v -r) )

i=0
len=${#array[@]}
while [ $i -lt $len ];
do  
    #echo ${array[$i]}
    ./bin/main $1 "datos_MDD/${array[$i]}"
    let i++
done

