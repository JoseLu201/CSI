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
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
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
?f <- (Juega J ?c)
(test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?c)
(Tablero Juego 1 ?c ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

;;;;(defrule _contrario_check_columna_libre
;;;;(declare (salience 1))
;;;;?f <- (Juega M ?c)
;;;;(Tablero Juego 1 ?c ?X) 
;;;;(test (neq ?X _))
;;;;=>
;;;;(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
;;;;(retract ?f)
;;;;)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defrule elegir_jugada_aleatoria
;(declare (salience -9998))
;?f <- (Turno M)
;=>
;(assert (Jugar (random 1 7)))
;(retract ?f)
;)
;
;(defrule comprobar_posible_jugada_aleatoria
;?f <- (Jugar ?c)
;(Tablero Juego 1 ?c M|J)
;=>
;(retract ?f)
;(assert (Turno M))
;)

;(defrule clisp_juega_sin_criterio
;(declare (salience -9999))
;?f<- (Jugar ?c)
;=>
;(retract ?f)
;(assert (Juega M ?c))
;(printout t "Juego sin razonar, que mal"  crlf) 
;)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(Tablero ?t ?i ?c4 ?jugador)
(test (= (+ ?c1 3) ?c4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?c  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
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

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;;;; ¡¡¡¡¡¡¡¡¡¡ Añadir conocimiento para que juege como vosotros jugariais !!!!!!!!!!!!


(defrule siguiente_horizontal
(Tablero Juego ?f ?c _ )
(test (< ?c 7))
=>
(assert (siguiente ?f ?c h ?f (+ ?c 1)))
)
;cambio
;(defrule siguiente_vertical
;(Tablero Juego ?f ?c _ )
;(test (< ?f 6))
;=>
;(assert (siguiente ?f ?c v (+ ?f 1) ?c))
;)
(defrule siguiente_vertical
(Tablero Juego ?f ?c _ )
(test (> ?f 1))
=>
(assert (siguiente ?f ?c v (- ?f 1) ?c))
)

;Diagonal de arriba abajo

(defrule siguiente_diagonal1
(Tablero Juego ?f ?c _ )
(test (< ?f 6))
(test (< ?c 7))
=>
(assert (siguiente ?f ?c d1 (+ ?f 1) (+ ?c 1)))
)

(defrule siguiente_diagonal2
(Tablero Juego ?f ?c _ )
(test (< ?f 6))
(test (< ?c 7))
=>
(assert (siguiente ?f ?c d2 (- ?f 1) (+ ?c 1)))
)



;;Puedo deducir con una sola regla todos los anteriores ya que conozco todos los siguientes

(defrule deduce_anterior
(siguiente ?f ?c ?d ?f1 ?c1)
=>
(assert (anterior ?f1 ?c1 ?d ?f ?c)))

;Ejercicio 2 Fila en la que caeria una ficha al meterla por cierta columna
; Donde p es el player jugando

;Esta es para el principio
(defrule cae_6
(Tablero Juego 6 ?c _)
=>
(assert (caeria 6 ?c))
)

;Como dice tenemos que actualizar el valor de caeria 
(defrule fila_caida
(declare (salience 15))
?f <- (caeria ?f1 ?c)
(Tablero ?t ?f1 ?c M|J) 

(test (> ?f1 1))
=>
(retract ?f)
(assert (caeria (- ?f1 1) ?c ))
;(printout t "Ejecutando "?f " " crlf)
)

(defrule elimina_overflow
?f <- (caeria ?f1 ?c)
(Tablero Juego ?f1 ?c M|J)
(test (eq ?f1 1))
=>
(retract ?f)
)




; 2 Fichas Conectadas

(defrule conect
(Tablero Juego ?f1 ?c1 ?p)
(siguiente ?f1 ?c1 ?d ?f2 ?c2)
(Tablero Juego ?f2 ?c2 ?p)
(test (neq ?p _)) ;Si el jugador es  blanco
=>
(assert (conectado ?d ?f1 ?c1 ?f2 ?c2 ?p))
)

;(defrule conect_ant
;(Tablero Juego ?f1 ?c1 ?p)
;(anterior ?f1 ?c1 ?d ?f2 ?c2)
;(Tablero Juego ?f2 ?c2 ?p)
;(test (neq ?p _)) ;Si el jugador no es  blanco
;=>
;(assert (conectado ?d ?f1 ?c1 ?f2 ?c2 ?p))
;)


;3 fichas conectadas

(defrule 3_conect_sig
(Tablero Juego ?f1 ?c1 ?p)
(Tablero Juego ?f2 ?c2 ?p)
(test (neq ?p _))
(siguiente ?f1 ?c1 ?d ?f2 ?c2) ; Obtengo la direccion
(conectado ?d ?f2 ?c2 ?f3 ?c3 ?p )
=>
(printout t "3seguidos1"crlf)
(assert (3_en_linea Juego ?d ?f1 ?c1 ?f3 ?c3 ?p))     
)


;gana en columna
(defrule posib_ganar
(3_en_linea Juego ?d ?f1 ?c1 ?f3 ?c3 ?p)
(siguiente ?f3 ?c3 ?d ?f4 ?c4)
(caeria ?f4 ?c4)
=>
(assert (ganaria ?p ?c4))  
(printout t "El jugador "?p " ganaria1 en " ?c4 crlf)
)

(defrule posib_ganar_2
(3_en_linea Juego ?d ?f1 ?c1 ?f3 ?c3 ?p)
(siguiente ?f1 ?c1 ?d ?f4 ?c4)
(caeria ?f4 ?c4)
=>
(assert (ganaria ?p ?c4))  
(printout t "El jugador "?p " ganaria2 en " ?c4 crlf)
)

(defrule posib_ganar_a1
(3_en_linea Juego ?d ?f1 ?c1 ?f3 ?c3 ?p)
(anterior ?f3 ?c3 ?d ?f4 ?c4)
(caeria ?f4 ?c4)
=>
(assert (ganaria ?p ?c4))  
(printout t "El jugador "?p " ganaria3 en " ?c4 crlf)
)

(defrule posib_ganar_2_a2
(3_en_linea Juego ?d ?f1 ?c1 ?f3 ?c3 ?p)
(anterior ?f1 ?c1 ?d ?f4 ?c4)
(caeria ?f4 ?c4)
=>
(assert (ganaria ?p ?c4))  
(printout t "El jugador "?p " ganaria4 en " ?c4 crlf)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;La del hueco xx_x

;;;;;;;;;;;;;;;;;;;;;;; SI EL JUGADOR BLOQUEA UNA JUGADA GANADORA DE LA MAQUINA
(defrule jugador_bloquea_ganadora
(declare (salience 9999))
?h <- (ganaria M ?columna)
(Juega J ?columna)
=>
(retract ?h)
(printout t "Peta n" crlf)
)

(defrule empezar_por_mitad
(Tablero Juego 6 4 _)
?f <- (Turno M)
=>
(retract ?f)
(assert (Juega M 4))
)

(defrule crear_2
(Tablero Juego ?f1 ?c1 M)
(siguiente ?f1 ?c1 ?d ?f2 ?c2)
(Tablero Juego ?f2 ?c2 ?p)
(test (neq ?p _))
?f <- (Turno M)
=>
(assert (Juega M ?c2))
(printout t "Siguientescoords " ?f2 " " ?c2 crlf)
(printout t "Early game " ?c2 crlf)
(retract ?f)
)

;;;;;;;;;;;;;;;;;;;;;;; CUANDO LA MAQUINA TIENE LA OPCION DE GANAR LO HACE DIRECTAMENTE COMO PRIMERA JUGADA
(defrule maquina_hace_jugada_ganadora
(declare (salience 9999))
?f <- (Turno M)
?g <- (ganaria M ?columna)
=>
(assert (Juega M ?columna))
(printout t "Jugada ganadora de M en " ?columna crlf)
(retract ?f ?g)
)
;;;;;;;;;; bloquear jugada ganadora 
(defrule maquina_bloquea_jugada_ganadora
?f <- (Turno M)
?g <- (ganaria J ?columna)
=>
(printout t "Bloqueo jugada ganadora en Columna " ?columna crlf)
(retract ?g ?f)
(assert (Juega M ?columna))
)

;;Puede fallar e intentar poner 
(defrule 3_conect_M
?h <- (Turno M)
(Tablero Juego ?f1 ?c1 ?M)
(Tablero Juego ?f2 ?c2 ?M)
(siguiente ?f1 ?c1 ?d ?f2 ?c2) ; Obtengo la direccion
(conectado ?d ?f2 ?c2 ?f3 ?c3 ?p )
;(test (< ?f3 1))
=>
(retract ?h)
(printout t "3 CONECTADOS DE M " ?f2 " " ?c2 " " ?f3 " " ?c3 crlf)
(assert (Juega M ?c3))
  
)

;;;defrule siguiente hay un hueco
(defrule sig_hueco
(Tablero Juego ?f1 ?c1 ?p)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?p)
(siguiente ?d ?f2 ?c2 ?f3 ?c3)
(Tablero Juego ?f3 ?c3 ?blank)
(test (neq ?blank _))
=>
(printout t "Peta1" crlf)
(assert (hueco ?p ?d ?f3 ?c3)) 
)

(defrule ant_hueco
(Tablero Juego ?f1 ?c1 ?p)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?p)
(anterior ?d ?f2 ?c2 ?f3 ?c3)
(Tablero Juego ?f3 ?c3 ?blank)
(test (neq ?blank _))
=>
(printout t "Peta2" crlf)
(assert (hueco ?p ?d ?f3 ?c3)) 
)
;;;;

(defrule ganaria_hueco_medio_sig
(Tablero Juego ?f1 ?c1 ?jugador)
(Tablero Juego ?f2 ?c2 ?jugador)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?jugador)  
(siguiente ?d ?f2 ?c2 ?f3 ?c3)
(hueco ?jugador ?d ?f3 ?c3)
(siguiente ?d ?f3 ?c3 ?f4 ?c4)
(Tablero Juego ?f4 ?c4 ?sameplayer)
(test (neq ?sameplayer ?jugador))
;;;;;;;;;
(caeria ?f4 ?c4)
=>
(printout t "Hay un 1hueco en " ?c4 "donde " ?jugador " gana" crlf)
(assert (ganaria ?jugador ?c4))
)

(defrule ganaria_hueco_medio_ant
(Tablero Juego ?f1 ?c1 ?jugador)
(Tablero Juego ?f2 ?c2 ?jugador)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?jugador)  
(anterior ?d ?f2 ?c2 ?f3 ?c3)
(hueco ?jugador ?d ?f3 ?c3)
(anterior ?d ?f3 ?c3 ?f4 ?c4)
(Tablero Juego ?f4 ?c4 ?sameplayer)
(test (neq ?sameplayer ?jugador))
;;;;;;;;;
(caeria ?f4 ?c4)
=>
(printout t "Hay un 2hueco en " ?c4 "donde " ?jugador " gana" crlf)
(assert (ganaria ?jugador ?c4))
)

(defrule ganaria_hueco_medio_sig_2
(Tablero Juego ?f1 ?c1 ?jugador)
(Tablero Juego ?f2 ?c2 ?jugador)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?jugador)  
(siguiente ?d ?f1 ?c1 ?f3 ?c3)
(hueco ?jugador ?d ?f3 ?c3)
(siguiente ?d ?f3 ?c3 ?f4 ?c4)
(Tablero Juego ?f4 ?c4 ?sameplayer)
(test (neq ?sameplayer ?jugador))
;;;;;;;;;
(caeria ?f4 ?c4)
=>
(printout t "Hay un 3hueco en " ?c4 "donde " ?jugador " gana" crlf)
(assert (ganaria ?jugador ?c4))
)

(defrule ganaria_hueco_medio_ant_2
(Tablero Juego ?f1 ?c1 ?jugador)
(Tablero Juego ?f2 ?c2 ?jugador)
(conectado ?d ?f1 ?c1 ?f2 ?c2 ?jugador)  
(anterior ?d ?f1 ?c1 ?f3 ?c3)
(hueco ?jugador ?d ?f3 ?c3)
(anterior ?d ?f3 ?c3 ?f4 ?c4)
(Tablero Juego ?f4 ?c4 ?sameplayer)
(test (neq ?sameplayer ?jugador))
;;;;;;;;;
(caeria ?f4 ?c4)
=>
(printout t "Hay un 4hueco en " ?c4 "donde " ?jugador " gana" crlf)
(assert (ganaria ?jugador ?c4))
)

(defrule BLOQUEO_hueco_medio_sig
(Tablero Juego ?fila ?columna ?jugador)
(test (neq ?jugador _)) 
(conectado ?d ?fila ?columna ?fila1 ?columna1 ?jugador)  
(Tablero Juego ?fila ?columna2 _)
(Tablero Juego ?fila ?columna3 ?jugador)
(test (or (and (eq ?columna2 (+ ?columna1 1)) (eq ?columna3 (+ ?columna1 2)))  (and (eq ?columna2 (- ?columna 1)) (eq ?columna3 (- ?columna 2))) ) )
(caeria ?fila ?columna2)
=>
(printout t "Hay un 5hueco en " ?columna2 "donde " ?jugador " gana" crlf)
(assert (ganaria ?jugador ?columna2))
)


(defrule clisp_juega_con_criterio
(declare (salience 9999))
?f<- (Jugar ?c)
=>
(printout t "------------------------------------------------" crlf) 
(printout t "Juego razonando en " ?c  crlf) 
(printout t "------------------------------------------------" crlf) 
(retract ?f)
(assert (Juega M ?c))
)

;(defrule elegir_jugada_aleatoria
;;(declare (salience -9998))
;?f <- (Turno M)
;(Juega M ?c2))
;=>
;(assert (Juega M ?c2))
;(retract ?f)
;)