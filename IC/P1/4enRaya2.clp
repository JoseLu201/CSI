;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?columna M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?columna M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIALIZAR ESTADO


(deffacts Estado_inicial
(Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
(Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
(Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
(Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
(Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
(Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
(Jugada 0)
)

(defrule Elige_quien_comienza
=>
(printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
(assert (Turno (read)))
)

;;;;;;;;;;;;;;;;;;;;;;; MUESTRA POSICION ;;;;;;;;;;;;;;;;;;;;;;;
(defrule muestra_posicion
(declare (salience 10))
(muestra_posicion)
(Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
(Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
(Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
(Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
(Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
(Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
=>
(printout t crlf)
(printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
(printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
(printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
(printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
(printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
(printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
(printout t  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
(declare (salience 9999))
(Turno J)
=>
(assert (muestra_posicion))
)

(defrule jugada_contrario
?f <- (Turno J)
=>
(printout t "en que columna introduces la siguiente ficha? ")
(assert (Juega J (read)))
(retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
(declare (salience 1))
?f <- (Juega J ?columna)
(test (and (neq ?columna 1) (and (neq ?columna 2) (and (neq ?columna 3) (and (neq ?columna 4) (and (neq ?columna 5) (and (neq ?columna 6) (neq ?columna 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?columna)
(Tablero Juego 1 ?columna ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?columna)
?g <- (Tablero Juego ?i ?columna _)
(Tablero Juego ?j ?columna ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?columna J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?columna)
?g <- (Tablero Juego 6 ?columna _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?columna J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?columna)
?g <- (Tablero Juego ?i ?columna _)
(Tablero Juego ?j ?columna ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?columna M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?columna)
?g <- (Tablero Juego 6 ?columna _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?columna M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule elegir_jugada_aleatoria
(declare (salience -9998))
?f <- (Turno M)
=>
(assert (Jugar (random 1 7)))
(retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
?f <- (Jugar ?columna)
(Tablero Juego 1 ?columna M|J)
=>
(retract ?f)
(assert (Turno M))
)

(defrule clisp_juega_sin_criterio
(declare (salience -9999))
?f<- (Jugar ?columna)
=>
(printout t "JUEGO en la columna (sin criterio) " ?columna crlf)
(retract ?f)
(assert (Juega M ?columna))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?columna1 ?jugador)
(Tablero ?t ?i ?columna2 ?jugador) 
(test (= (+ ?columna1 1) ?columna2))
(Tablero ?t ?i ?columna3 ?jugador)
(test (= (+ ?columna1 2) ?columna3))
(Tablero ?t ?i ?columna4 ?jugador)
(test (= (+ ?columna1 3) ?columna4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?columna1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?columna ?jugador)
(Tablero ?t ?i2 ?columna ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?columna  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?columna  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?columna))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?columna ?jugador)
(Tablero ?t ?i1 ?columna1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?columna 1) ?columna1))
(Tablero ?t ?i2 ?columna2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?columna 2) ?columna2))
(Tablero ?t ?i3 ?columna3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?columna 3) ?columna3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?columna))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?columna ?jugador)
(Tablero ?t ?i1 ?columna1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?columna 1) ?columna1))
(Tablero ?t ?i2 ?columna2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?columna 2) ?columna2))
(Tablero ?t ?i3 ?columna3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?columna 3) ?columna3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?columna))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?columna)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?columna)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?columna crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?columna)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?columna   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?columna)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?columna   crlf)
(retract ?f)
(assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
(declare (salience -9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE NUEVO PORQUE NO FUNCIONABA

(defrule nuevo_detecta_empate
(declare (salience 9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;

(deffacts caida_sin_fichas
	(caeria 6 1) 
	(caeria 6 2) 
	(caeria 6 3) 
	(caeria 6 4) 
	(caeria 6 5) 
	(caeria 6 6) 
	(caeria 6 7)
)


;----------------------PRIMER EJERCICIO-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION SIGUIENTE EN HORIZONTAL
(defrule sig_hor
(Tablero Juego ?fila ?columna ?jugador)
(test (< ?columna 7))
=>
(assert (siguiente ?fila ?columna h ?fila (+ ?columna 1)))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION SIGUIENTE EN VERTICAL
(defrule sig_ver
(Tablero Juego ?fila ?columna ?jugador)
(test (< ?fila 6))
=>
(assert (siguiente ?fila ?columna v (+ ?fila 1) ?columna))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION SIGUIENTE EN LA DIAGONAL 1
(defrule sig_d1
(Tablero Juego ?fila ?columna ?jugador)
(test (and (< ?fila 6) (< ?columna 7)))
=>
(assert (siguiente ?fila ?columna d1 (+ ?fila 1) (+ ?columna 1)))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION SIGUIENTE EN LA DIAGONAL 2
(defrule sig_d2
(Tablero Juego ?fila ?columna ?jugador)
(test (and (> ?fila 1) (< ?columna 7)))
=>
(assert (siguiente ?fila ?columna d2 (- ?fila 1) (+ ?columna 1)))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION ANTERIOR EN LA HORIZONTAL
(defrule ant_hor
(Tablero Juego ?fila ?columna ?jugador)
(test (> ?columna 1))
=>
(assert (anterior ?fila ?columna h ?fila (- ?columna 1)))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION ANTERIOR EN LA VERTICAL
(defrule ant_ver
(Tablero Juego ?fila ?columna ?jugador)
(test (> ?fila 1))
=>
(assert (anterior ?fila ?columna v (- ?fila 1) ?columna))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION ANTERIOR EN LA DIAGONAL 1
(defrule ant_d1
(Tablero Juego ?fila ?columna ?jugador)
(test (and (> ?fila 1) (> ?columna 1)))
=>
(assert (anterior ?fila ?columna d1 (- ?fila 1) (- ?columna 1)))
)

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA POSICION ANTERIOR EN LA DIAGONAL 2
(defrule ant_d2
(Tablero Juego ?fila ?columna ?jugador)
(test (and (< ?fila 6) (> ?columna 1)))
=>
(assert (anterior ?fila ?columna d2 (+ ?fila 1) (- ?columna 1)))
)


;----------------------SEGUNDO EJERCICIO-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; OBTENER LA FILA EN LA QUE CAERIA UNA FICHA AL METERLA EN UNA COLUMNA
(defrule donde_caeria
(declare (salience 9998))
(Tablero Juego ?fila ?columna _)
(Tablero Juego ?j ?columna ?X)
(test (= (+ ?fila 1) ?j))
(test (neq ?X _))
=>
(assert (caeria ?fila ?columna))
)



;;;;;;;;;;;;;;;;;;;;;;; CUANDO SE JUEGA EN UNA COLUMNA, EL CAERIA SE DEBE ACTUALIZAR PORQUE CAERIA EN UNA FILA MAS ARRIBA SI LAS HUBIESE
(defrule elimina_posicion_ocupada
(declare (salience 9997))
(Tablero Juego ?j ?columna ?X)
(test (neq ?X _))
?f <- (caeria ?j ?columna)
=>
(retract ?f)
)



;----------------------TERCER EJERCICIO-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA FICHAS CONECTADAS A PARES EN HORIZONTAL
(defrule encontrar_conectados_horizontal
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(siguiente ?fila ?columna h ?fila1 ?columna1)
(Tablero Juego ?fila1 ?columna1 ?jugador)
=>
(assert (conectado Juego h ?fila ?columna ?fila1 ?columna1 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA FICHAS CONECTADAS A PARES EN VERTICAL
(defrule encontrar_conectados_vertical
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _))
(anterior ?fila ?columna v ?fila1 ?columna1)
(Tablero Juego ?fila1 ?columna1 ?jugador)
=>
(assert (conectado Juego v ?fila ?columna ?fila1 ?columna1 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA FICHAS CONECTADAS A PARES EN LA DIAGONAL 1
(defrule encontrar_conectados_d1
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(siguiente ?fila ?columna d1 ?fila1 ?columna1)
(Tablero Juego ?fila1 ?columna1 ?jugador)
=>
(assert (conectado Juego d1 ?fila ?columna ?fila1 ?columna1 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA FICHAS CONECTADAS A PARES EN LA DIAGONAL 2
(defrule encontrar_conectados_d2
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(siguiente ?fila ?columna d2 ?fila1 ?columna1)
(Tablero Juego ?fila1 ?columna1 ?jugador)
=>
(assert (conectado Juego d2 ?fila ?columna ?fila1 ?columna1 ?jugador))
)


;----------------------CUARTO EJERCICIO-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA 3 FICHAS CONECTADAS EN HORIZONTAL
(defrule encontrar_3_raya_hor
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego h ?fila ?columna ?fila1 ?columna1 ?jugador)
(siguiente ?fila1 ?columna1 h ?fila2 ?columna2)
(Tablero Juego ?fila2 ?columna2 ?jugador)
=>
(assert (3_en_linea Juego h ?fila ?columna ?fila2 ?columna2 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA 3 FICHAS CONECTADAS EN VERTICAL
(defrule encontrar_3_raya_ver
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego v ?fila ?columna ?fila1 ?columna1 ?jugador)
(anterior ?fila1 ?columna1 v ?fila2 ?columna2)
(Tablero Juego ?fila2 ?columna2 ?jugador)
=>
(assert (3_en_linea Juego v ?fila ?columna ?fila2 ?columna2 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA 3 FICHAS CONECTADAS EN LA DIAGONAL1
(defrule encontrar_3_raya_d1
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d1 ?fila ?columna ?fila1 ?columna1 ?jugador)
(siguiente ?fila1 ?columna1 d1 ?fila2 ?columna2)
(Tablero Juego ?fila2 ?columna2 ?jugador)
=>
(assert (3_en_linea Juego d1 ?fila ?columna ?fila2 ?columna2 ?jugador))
)

;;;;;;;;;;;;;;;;;;;;;;; ENCUENTRA 3 FICHAS CONECTADAS EN LA DIAGONAL2
(defrule encontrar_3_raya_d2
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d2 ?fila ?columna ?fila1 ?columna1 ?jugador)
(siguiente ?fila1 ?columna1 d2 ?fila2 ?columna2)
(Tablero Juego ?fila2 ?columna2 ?jugador)
=>
(assert (3_en_linea Juego d2 ?fila ?columna ?fila2 ?columna2 ?jugador))
)



;----------------------QUINTO EJERCICIO-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI EXISTEN 3 EN RAYA Y PUEDE CONTINUARLO EN HORIZONTAL
(defrule ganaria_hor
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(3_en_linea Juego h ?fila ?columna ?fila1 ?columna1 ?jugador)
(caeria ?fila1 ?columna2)  
(test (or (eq ?columna2 (+ ?columna1 1)) (eq ?columna2 (- ?columna 1)) ) ) 
=>
(assert (ganaria ?jugador ?columna2) )
)

;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI EXISTEN 3 EN RAYA Y PUEDE CONTINUARLO EN VERTICAL
(defrule ganaria_ver
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(3_en_linea Juego v ?fila ?columna ?fila1 ?columna2 ?jugador)
(caeria ?fila2 ?columna2)  
(test (eq ?fila2 (- ?fila1 1)) )
=>
(assert (ganaria ?jugador ?columna2) )
)


;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI EXISTEN 3 EN RAYA Y PUEDE CONTINUARLO EN LA DIAGONAL1
(defrule ganaria_d1
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(3_en_linea Juego d1 ?fila ?columna ?fila1 ?columna1 ?jugador)
(caeria ?fila2 ?columna2) 
(test (or (and (eq ?columna2 (+ ?columna1 1)) (eq ?fila2 (+ ?fila1 1)))  (and (eq ?columna2 (- ?columna 1)) (eq ?fila2 (- ?fila 1))) ) ) 
=>
(assert (ganaria ?jugador ?columna2) )
)

;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI EXISTEN 3 EN RAYA Y PUEDE CONTINUARLO EN LA DIAGONAL2
(defrule ganaria_d2
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(3_en_linea Juego d2 ?fila ?columna ?fila1 ?columna1 ?jugador)
(caeria ?fila2 ?columna2)  
(test (or (and (eq ?columna2 (+ ?columna1 1)) (eq ?fila2 (- ?fila1 1)))  (and (eq ?columna2 (- ?columna 1)) (eq ?fila2 (+ ?fila 1))) ) )
=>
(assert (ganaria ?jugador ?columna2) )
)

;----------------------FIN DE LOS EJERCICIOS-----------------------------------------

;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI RELLENANDO UN HUECO INTERMEDIO HORIZONTAL HACE 4 EN RAYAS
(defrule ganaria_hor_hueco_medio
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego h ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila ?columna2 _)
(Tablero Juego ?fila ?columna3 ?jugador)
(test (or (and (eq ?columna2 (+ ?columna1 1)) (eq ?columna3 (+ ?columna1 2)))  (and (eq ?columna2 (- ?columna 1)) (eq ?columna3 (- ?columna 2))) ) )
(caeria ?fila ?columna2)
=>
(assert (ganaria ?jugador ?columna2))
)

;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI RELLENANDO UN HUECO INTERMEDIO DIAGONAL1 HACIA LA DERECHA
(defrule ganaria_d1_derecha_hueco_medio
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d1 ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila2 ?columna2 _)
(Tablero Juego ?fila3 ?columna3 ?jugador)
(test (and (and (eq ?fila2 (+ ?fila1 1)) (eq ?fila3 (+ ?fila1 2))) (and (eq ?columna2 (+ ?columna1 1)) (eq ?columna3 (+ ?columna1 2)) )))
(caeria ?fila2 ?columna2)
=>
(assert (ganaria ?jugador ?columna2))
)


;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI RELLENANDO UN HUECO INTERMEDIO DIAGONAL1 HACIA LA IZQUIERDA
(defrule ganaria_d1_izquierda_hueco_medio
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d1 ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila2 ?columna2 _)
(Tablero Juego ?fila3 ?columna3 ?jugador)
(test (and (and (eq ?columna2 (- ?columna 1)) (eq ?columna3 (- ?columna 2))) (and (eq ?fila2 (- ?fila 1)) (eq ?fila3 (- ?fila 2)) )))
(caeria ?fila2 ?columna2)
=>
(assert (ganaria ?jugador ?columna2))
)


;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI RELLENANDO UN HUECO INTERMEDIO DIAGONAL2 HACIA LA DERECHA
(defrule ganaria_d2_derecha_hueco_medio
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d2 ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila2 ?columna2 _)
(Tablero Juego ?fila3 ?columna3 ?jugador)
(test (and (and (eq ?fila2 (- ?fila1 1)) (eq ?fila3 (- ?fila1 2))) (and (eq ?columna2 (+ ?columna1 1)) (eq ?columna3 (+ ?columna1 2)) )))
(caeria ?fila2 ?columna2)
=>
(assert (ganaria ?jugador ?columna2))
)


;;;;;;;;;;;;;;;;;;;;;;; DETECTAMOS QUE LA PERSONA O LA MAQUINA GANARIA SI RELLENANDO UN HUECO INTERMEDIO DIAGONAL2 HACIA LA IZQUIERDA
(defrule ganaria_d2_izquierda_hueco_medio
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado Juego d2 ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila2 ?columna2 _)
(Tablero Juego ?fila3 ?columna3 ?jugador)
(test (and (and (eq ?columna2 (- ?columna 1)) (eq ?columna3 (- ?columna 2))) (and (eq ?fila2 (+ ?fila 1)) (eq ?fila3 (+ ?fila 2)) )))
(caeria ?fila2 ?columna2)
=>
(assert (ganaria ?jugador ?columna2))
)


;;;;;;;;;;;;;;;;;;;;;;; SI TENEMOS LA OPCION DE PONER 3 EN RAYAS CUANDO YA TENEMOS DOS CONECTADAS EN LA DIAGONAL 2
(defrule conectar_3_teniendo_2_diagonal2
?h <- (Turno M)
(conectado Juego d2 ?fila ?columna ?fila1 ?columna1 M)
(caeria ?fila2 ?columna2)
(test (or (and (eq ?fila2 (- ?fila1 1)) (eq ?columna2 (+ ?columna1 1))) (and (eq ?fila2 (+ ?fila 1))  (eq ?columna2 (- ?columna 1)) )))
=>
(retract ?h)
(assert (Juega M ?columna2))
)

;;;;;;;;;;;;;;;;;;;;;;; SI EL JUGADOR BLOQUEA UNA JUGADA GANADORA DE LA MAQUINA
(defrule jugador_bloquea_ganadora
(declare (salience 9999))
?h <- (ganaria M ?columna)
(Juega J ?columna)
=>
(retract ?h)
)

;;;;;;;;;;;;;;;;;;;;;;; CUANDO TIENE DOS FICHAS SEPARADAS POR UN HUECO
(defrule dos_fichas_con_hueco
?h <- (Turno M)
(Tablero Juego ?fila ?columna M)
(Tablero Juego ?fila ?columna2 M)
(Tablero Juego ?fila ?columna1 _)
(Tablero Juego ?fila ?columna4 _)
(caeria ?fila1?columna1)
(caeria ?fila ?columna4)
(test (and (eq ?columna2 (+ ?columna 2)) (eq ?columna1 (+ ?columna 1)) ))
(test (or (eq ?columna4 (- ?columna 1)) (eq ?columna4 (+ ?columna2 1)) ) )
=>
(assert (Juega M ?columna1))
(retract ?h)
)


;;;;;;;;;;;;;;;;;;;;;;; LA MAQUINA EMPIEZA EN EL CENTRO PARA TENER MAS OPCIONES DE GANAR SIEMPRE. ES LO QUE HARIA UN HUMANO
(defrule empezar_por_mitad
(Tablero Juego 6 4 _)
?f <- (Turno M)
=>
(retract ?f)
(assert (Juega M 4))
)


;;;;;;;;;;;;;;;;;;;;;;; SI EMPIEZA EL JUGADOR Y ESTE PONE EN EL CENTRO, CORTAMOS SU DESARROLLO POR AL MENOS UNO DE LOS LADOS
(defrule bloquear_inicio_jugador  
(Tablero Juego 6 4 J)
(Tablero Juego 6 5 _)
?f <- (Turno M)
=>
(retract ?f)
(assert (Juega M 5))
)



;;;;;;;;;;;;;;;;;;;;;;; CUANDO LA MAQUINA TIENE LA OPCION DE GANAR LO HACE DIRECTAMENTE COMO PRIMERA JUGADA
(defrule maquina_hace_jugada_ganadora
(declare (salience 9999))
?f <- (Turno M)
?g <- (ganaria M ?columna)
=>
(assert (Juega M ?columna))
(retract ?f ?g)
)

;;;;;;;;;;;;;;;;;;;;;;; CUANDO LA MAQUINA TAPA UNA JUGADA GANADORA DEL JUGADOR. ESTO ES PRIORITARIO Y DEBE SER LO QUE ANTES HAGA
;;;;;;;;;;;;;;;;;;;;;;; POR DETRAS SOLO DE GANAR
(defrule maquina_bloquea_jugada_ganadora
?f <- (Turno M)
?g <- (ganaria J ?columna)
=>
(retract ?g ?f)
(assert (Juega M ?columna))
)

;;;;;;;;;;;;;;;;;;;;;;; SI TENEMOS LA OPCION DE PONER 3 EN RAYAS CUANDO YA TENEMOS DOS CONECTADAS EN LA HORIZONTAL
(defrule conectar_3_teniendo_2_horizontal
?h <- (Turno M)
(conectado Juego h ?fila ?columna ?fila2 ?columna1 M)
(caeria ?fila2 ?columna2)
(Tablero Juego ?fila3 ?columna3 _)
(test (or (and (eq ?columna2 (+ ?columna1 1)) (or  (eq ?columna3 (+ ?columna1 2)) (eq ?columna3 (- ?columna 1)))) (and (eq ?columna2 (- ?columna 1))  (or  (eq ?columna3 (- ?columna 2)) (eq ?columna3 (+ ?columna1 1)) ) ) ))
=>
(retract ?h)
(assert (Juega M ?columna2))
)

;;;;;;;;;;;;;;;;;;;;;;; SI TENEMOS LA OPCION DE PONER 3 EN RAYAS CUANDO YA TENEMOS DOS CONECTADAS EN LA VERTICAL
(defrule conectar_3_teniendo_2_vertical
?h <- (Turno M)
(conectado Juego v ?fila ?columna ?fila1 ?columna1 M)
(caeria ?fila2 ?columna1)
(test (and (eq ?fila2 (- ?fila1 1)) (> ?fila2 1) ) )
=>
(retract ?h)
(assert (Juega M ?columna1))
)

;;;;;;;;;;;;;;;;;;;;;;; SI TENEMOS LA OPCION DE PONER 3 EN RAYAS CUANDO YA TENEMOS DOS CONECTADAS EN LA DIAGONAL 1
(defrule conectar_3_teniendo_2_diagonal1
?h <- (Turno M)
(conectado Juego d1 ?fila ?columna ?fila1 ?columna1 M)
(caeria ?fila2 ?columna2)
(test (or (and (eq ?fila2 (+ ?fila1 1)) (eq ?columna2 (+ ?columna1 1)))  (and (eq ?fila2 (- ?fila 1))  (eq ?columna2 (- ?columna 1)) ) ))
=>
(retract ?h)
(assert (Juega M ?columna2))
)






















