; ( FactorCerteza ?h si|no ?f)  representa que ?h se ha deducido con factor de certeza ?f 
 ;?h podrá_ser:
; - problema_starter
; - problema_bujias
; - problema_batería
; - motor_llega_gasolina 

; (Evidencia ?e si|no ) representa el hecho de si evidencia ?e se da 
; ?e p odrá ser:
; - hace_intentos_arrancar
; - hay_gasolina_en_deposito 
; - encienden_las_luces
; -gira_motor





;;;Convertimos cada evidencia en una afirmacion sobre su factor de certeza
(defrule certeza_evidencias
(Evidencia ?e ?r)
=>
(assert (FactorCerteza ?e ?r 1))
)

(deffunction encadenado ( ?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0) then 
    (bind ?rv (* ?fc_antecedente ?fc_regla))
else
    (bind ?rv 0)
)
?rv)

;; También podríamos considerar evidencias con una cierta 
;;incertidumbre: al preguntar por la evidencia, pedir y recoger 
;;directamente el grado de certeza

;;;Funcion de combinacion
(deffunction combinacion (?fc1 ?fc2)
    (if (and (> ?fc1 0) (> ?fc2 0)) then
        (bind ?rv (-(+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
    else
        (if (and (< ?fc1 0) (< ?fc2 0)) then
            (bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
        else
            (bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2)))))
        )
    )
?rv)

;;Combinar misma deduccion por distintos caminos
(defrule combinar
(declare (salience 1))
    ?f<-(FactorCerteza ?h ?r ?fc1)
    ?g<-(FactorCerteza ?h ?r ?fc2)
    (test (neq ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2)))
)



;;;; certeza de las hipotesis
(defrule combinar_signo
    (declare (salience 2))
    (FactorCerteza ?h si ?fc1)
    (FactorCerteza ?h no ?fc2)
=>
    (assert (Certeza ?h (- ?fc1 ?fc2)))
)

;;R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías con certeza 0.7
(defrule R1
    (FactorCerteza motor_llega_gasolina si ?f1)
    (FactorCerteza gira_motor si ?f2)
    (test (and (> ?f1 0) (> ?f2 0)))
=>
    (assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
)

;;R2: SI el motor no gira ENTONCES problemas con el starter con certeza 0.8
(defrule R2
    (FactorCerteza gira_motor no ?f1)
    (test (> ?f1 0))
=>
    (assert (FactorCerteza problema_starter si (encadenado ?f1 0.8)))
)
;;R3: SI no enciende las luces ENTONCES problemas con la bateria con certeza 0.9
(defrule R3
    (FactorCerteza encienden_las_luces no ?f1)
    (test (> ?f1 0))
=>
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9)))
)


;R4: SI tiene gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0.9
(defrule R4
    (FactorCerteza hay_gasolina_en_deposito si ?f1)
    (test (> ?f1 0))
=>
    (assert (FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9)))

)


;;R5 y R6: SI hace intentos de arrancar ENTONCES problemas con el starter con certeza -0.6
(defrule R5
    (FactorCerteza hace_intentos_arrancar si ?f1)
    (test (> ?f1 0))
=>
    (assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6)))
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5)))
)


;;añado una variable inicialmente por defectoa0;;
(defrule default
    (declare (salience 10))
=>
    (assert (hip_max desconocido 0))
)

; Como pide, me quedo con la hipotesis con mayor valor de certeza
; Entonces para cada problema me quedo 
(defrule hipotesis_bujias
    ?f <- (FactorCerteza problema_bujias si ?fc1)
    ?g <- (hip_max ?hip ?fc2)
    (test (> ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (hip_max problema_bujias ?fc1))
)

(defrule hipotesis_starter
    ?f <- (FactorCerteza problema_starter si ?fc1)
    ?g <- (hip_max ?hip ?fc2)
    (test(> ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (hip_max problema_starter ?fc1))
)

(defrule hipotesis_bateria
    ?f <- (FactorCerteza problema_bateria si ?fc1)
    ?g <- (hip_max ?hip ?fc2)
    (test(> ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (hip_max problema_bateria ?fc1))
)


; Preguntamos por las posibles evidencias
;   -Si gira motor
;   -Si enciende_luces
;   -Si tiene_gasolina_deposito
;   -Si hace_intentos_arrancar

; Y anotamos la Evidencia
(defrule gira_motor
    (declare (salience 5))
=>
    (printout t "Gira el motor? (si/no) ")
    (assert (Evidencia gira_motor (read)))
)

(defrule enciende_luces
    (declare (salience 5))
=>
    (printout t "Se encienden las luces? (si/no) ")
    (assert (Evidencia encienden_las_luces (read)))
)

(defrule tiene_gasolina_deposito
    (declare (salience 5))
=>
    (printout t "Tiene gasolina el deposito? (si/no) ")
    (assert (Evidencia hay_gasolina_en_deposito (read)))
)

(defrule hace_intentos_arrancar
    (declare (salience 5))
=>
    (printout t "Hace el intento de arrancar? (si/no) ")
    (assert (Evidencia hace_intentos_arrancar (read)))
)

; Como ya tenemos la la hipotesis mas probable 
(defrule decision_problema_bujias
(declare (salience -4))
?f <- (hip_max ?hip ?fc)
(test (and (> ?fc 0) (eq ?hip problema_bujias)))
=>
(retract ?f)
(assert (hipotesis_final "problema es de las bujias" ?fc))
)

(defrule decision_problema_starter
(declare (salience -4))
?f <-(hip_max ?hip ?fc)
(test (and (> ?fc 0) (eq ?hip problema_starter)))
=>
(retract ?f)
(assert (hipotesis_final "problema esta en el starter" ?fc))
)

(defrule decision_problema_bateria
(declare (salience -4))
?f <- (hip_max ?hip ?fc)
(test (and (> ?fc 0) (eq ?hip problema_bateria)))
=>
(retract ?f)
(assert (hipotesis_final "problema esta en la bateria" ?fc))
)

;; Imprimo el razonamiento de factor de certeza
(defrule decision_final
(declare (salience -5))
(hipotesis_final ?hip ?fc)
(test (> ?fc 0))
=>
(printout t "Deducimos a un " (* ?fc 100) "% de certeza que el " ?hip ""crlf)
)