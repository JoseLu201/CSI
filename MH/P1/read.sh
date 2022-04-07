#!/bin/bash

array=( $( ls ./datos_MDD -1v) )

i=0
len=${#array[@]}
while [ $i -lt $len ];
do  
    echo ${array[$i]}
    #echo "./bin/main datos_MDD/${array[$i]}"
    ./bin/main "datos_MDD/${array[$i]}" 
    let i++
done

