;;;Convertimos cada evidencia en una afirmacion sobre su factor de certeza
(defrule certeza_evidencias
(Evidencia ?e ?r)
=>
(assert (FactorCerteza ?e ?r 1))
)

(deffunction encadenado (?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0) then
    (bind ?rv (* ?fc_antecedente ?fc_regla))
else
    (bind ?rv 0))
?rv)

;;;Funcion de combinacion
(deffunction combinacion (?fc1 ?fc2)
    (if (and (>?fc1 0) (> ?fc2 0)) then
        (bind ?rv (-(+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
    else
        (if (and ( ?fc1 0) (< ?fc2 0)) then
            (bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
        else
            (bind ?rv (/ (+ ?fc1 ?fc2) (-1 (min (abs ?fc1) (abs ?fc2)))))
        )
    )
?rv)

;;Combinar misma deduccion por distintos caminos
(defrule combinar
(declare (salience 1))
?f<-(FactorCerteza ?h ?r ?fc1)
?g -(FactorCerteza ?h ?r ?fc2)
(test (neq ?fc1 ?fc2))
=>
(retract ?f ?g)
(assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2)))
)

;R4: SI tiene gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0.9
(defrule R4
(FactorCerteza hay_gasolina_en_deposito si ?f1)
(test (>?f1 0))
(assert (FactorCerteza motor_|lega_gasolina si (encadenado ?f1 0.9)))

)

;;R2: SIel motor no gira ENTONCES problemas con el starter con certeza 0.8
(defrule R2
(FactorCerteza gira_motor no ?f1)
(test (> Pf1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 0.8))
)
)
;;R3: SI no enciende las luces ENTONCES problemas con la bateria con certeza 0.9
(defrule R3
(FactorCerteza encienden_las_luces no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9)))
)

;;R5 y R6: SI hace intentos de arrancar ENTONCES problemas con el starter con certeza -0.6
(defrule R5
(FactorCerteza hace_intentos_arrancar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6)))
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5)))
)

;;R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0.7
(defrule R1
(FactorCerteza motor_llega_gasolina si ?f1)
(FactorCerteza gira_motor si ?f2)
;;;;;;;;;;;;;;;;;;;;;;;test (and (> ?f1 0) (> ?12 0)))
=>
(assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
)

;;me quedo con la hipotesis con mayor valor de certeza
(defrule hipotesis_1
?f <- (FactorCerteza problema_bujias si ?x1)
?g <- (hip_max ?hip ?x2)
(test (>?x1 ?x2))
=>
(retract ?f ?g)
(assert (hip_max problema_bujias ?x1))
)

(defrule hipotesis_2
?f <- (FactorCerteza problema_starter si ?x1)
?g <- (hip_max ?hip ?x2)
(test(?x1 ?x2))
=>
(retract ?f ?g)
(assert (hip_max problema_starter ?x1))
)

(defrule hipotesis_3
?f <- (FactorCerteza problema_bateria si ?x1)
?g <- (hip_max ?hip ?x2)
(test(>?x1 ?x2))
=>
(retract ?f ?g)
(assert (hip_max problema_bateria ?x1))
)

;;añado una variable inicialmente por defectoa0;;
(defrule default
(declare (salience 7))
=>
(assert (hip_max desconocido 0))
)

;;;; certeza de las hipotesis
(defrule combinar_signo
(declare (salience 2))
(FactorCerteza ?h si ?fc1)
(FactorCerteza ?h no ?fc2)
=>
(assert (Certeza ?h (- ?fc1 ?fc2)))
)

;; pregunta si el motor gira 
(defrule puede_gira_motor
(declare (salience 5))
=>
(printout t "Gira el motor? (si o no) ")
(assert (Evidencia gira_motor (read)))
)

;; pregunta si se enciende las luces
(defrule se_enciende_luces
(declare (salience 5))
=>
(printout t "Se encienden las luces? (si o no) ")
(assert (Evidencia encienden_las_luces (read)))
)
;pregunta si tiene gasolina en el deposito 
(defrule tiene_gasolina_deposito
(declare (salience 5))
=>
(printout t "tiene gasolina el deposito? (si o no) ")
(assert (Evidencia hay_gasolina_en_deposito (read)))
)

;pregunta si intenta arrancar
(defrule hace_intentos_arrancar
(declare (salience 5))
=>
(printout t "Hace el intento de arrancar? (si o no) ")
(assert (Evidencia hace_intentos_arrancar (read)))
)

; Cuando ya tenga decidido que hipotesis es hace su explicación ;
(defrule decision1
(declare (salience -4))
?f <- (hip_max ?hip ?x)
(test (and (> ?x 0) (eq ?hip problema_bujias)))
=>
(retract ?f)
(assert (hipotesis_final "problema es de las bujias" ?x))
)

(defrule decision2
(declare (salience -4))
?f <-(hip_max ?hip ?x)
(test (and (> ?x 0) (eq ?hip problema_starter)))
=>
(retract ?f)
(assert (hipotesis_final "problema esta en el starter" ?x))
)

(defrule decision3
(declare (salience -4))
?f <- (hip_max ?hip ?x)
(test (and (?x 0) (eq ?hip problema_bateria)))
=>
(retract ?)
(assert (hipotesis_final "problema esta en la bateria" ?x))
)

;; Imprimo el razonamiento de factor de certeza
(defrule imprime decision_final
(declare (salience -5))
(hipotesis_final ?hip ?x)
(test (> ?x 0))
(printout t "El sistema deduce que el " ?hip ", porque hay un " (* ?x 100) "% de certeza
de que sea ese el problema" crlf)
)