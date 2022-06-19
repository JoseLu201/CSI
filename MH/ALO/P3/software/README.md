Esta practica implementa una clase MDD con los dos algoritmos.
Podemos hacer make para compilar los fuentes y como resultado el ejecutable lo almacenaremos en /bin con el nombre de main
A este ejecutable le tenemos que pasar dos argumentos, el algoritmo a ejecutar, he puesto que:
    -> El numero 1 sera el Enfriamiento Simulado
    -> El numero 2 sera la BMB
    -> El numero 3 sera la ILS
    -> El numero 4 sera la ILS_ES


Y como segundo parametro sera el archivo sobre el el que ejecutar las pruebas que estan en datos_MDD/
un ejemplo de uso seria " make && ./bin/main 1 datos_MDD/GKD-b_10_n25_m7.txt ", aqui compilamos y le ordenamos que ejecute el AGG_posicion con (datos_MDD/GKD-b_10_n25_m7.txt) estos datos

El output que obtendremos será el fitness de la solucion, junto con el tiempo que ha tardado, estos separados por punto y coma, (para que sea mas facil pasarlos al excel, las tabulaciones no funcionan)

Para agilizar el proceso de test he realizado un script sencillo read_test.sh que guarda en un array todos los datos en un array ordenadamente e ira ejecutando todos los test.
Ejemplo de uso make && ./read_test.sh 1, en este caso volvemos a compilar si es necesario y despues ejectuamos el script indicando el algoritmo.
