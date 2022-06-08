#!/bin/bash

for i in {25..99}; do 
    sed -i "s/(< (coste) ${i})/(< (coste) $(expr $i + 1))/" problema6.pddl
    ./Metric-FF/ff -o dominio6.pddl -f problema6.pddl -O -g 1 -h 1 | grep "seconds total time"
done
#Volvemos a ponerlo de la forma correcta
sed -i "s/(< (coste) 100)/(< (coste) 25)/" problema6.pddl