#!/bin/bash

array=( $( ls ./datos_MDD -1v) )

i=0
len=${#array[@]}
while [ $i -lt $len ];
do  
    #echo ${array[$i]} >> output.txt
    ./bin/main "datos_MDD/${array[$i]}" >> output.txt
    let i++
done

