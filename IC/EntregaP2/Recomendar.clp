(deffacts Ramas
  (Rama CSI )   ;Computacion_y_Sistemas_Inteligentes
  (Rama IS )    ;Ingenieria_del_Software
  (Rama IC )    ;Ingenieria_de_Computadores
  (Rama SI )    ;Sistemas_de_Informacion
  (Rama TI )    ;Tecnologias_de_la_Informacion
)

;;Dar la bienvenida y muestro las ramas disponibles
(defrule Welcome
    (declare (salience 10))
=>
      (printout t "Bienvenido al sistema de asesoramiento de ramas del Grado en I. Informatica. Las ramas son:" crlf)
  (printout t "- Computacion y Sistemas Inteligentes." crlf)
  (printout t "- Ingenieria del Software." crlf)
  (printout t "- Ingenieria de Computadores." crlf)
  (printout t "- Sistemas de Informacion." crlf)
  (printout t "- Tecnologias de la Informacion." crlf)
)

;;Inicializo algunos valores que necesito
(defrule init
(declare (salience 1000))
=>
(assert (descarto Rama NONE))
(assert (first TRUE))
(assert (final TRUE))
(assert (preferencia _ "Porque "))
(assert (avoid_loop TRUE))
(assert (avoid_loop2 TRUE))
(assert (Consejo _ _))
)
;;;SI tiene seguro que hay alguna que no quieres elegir en principio
;;puedes decirla y el sistema intentara no escogerla
(defrule descartar
(declare (salience 9))
?f <- (descarto Rama NONE)
=>
(printout t "Hay alguna rama que tengas seguro que no quieres escoger, indica su nombre(CSI/IS...), en caso contrario pon NONE " crlf)
  (assert (descarto Rama (read)))
  (printout t "Okay no escogeremos eso rama en principio" crlf)
)

;;Pregunto si prefiere el software sobre el hardware o le da igual, 
;;para adquirir una idea inicial de sus gustos mas genericos
(defrule ask_soft
=>  
(printout t "Prefires el software sobre el hardware (SI/ NO / IGUAL)" crlf)
(bind ?ans(read))

(assert (pref_software ?ans))
(assert (Evidencia pref_software ?ans))
)

;;Igual para hardware
(defrule ask_hard
=>
(printout t "Prefires el hardware sobre el software (SI/ NO / IGUAL)" crlf)
(assert (pref_hardware(read)))
)

;;Primera aproximacion a elegir entre ramas destinadas a software o destinadas a hardware,
;;en algunos casos puede no ser decisivo
(defrule decide_ware
(pref_software ?soft)
(pref_hardware ?hard)
=>
;;Le gusta el software y no el hard
    (if (or (and (eq (upcase ?soft) SI) (eq (upcase ?hard) NO)) 
            (and (eq (upcase ?soft) SI) (eq (upcase ?hard) IGUAL))
            (and (eq (upcase ?soft) IGUAL) (eq (upcase ?hard) NO))) then
        (printout t "Prefieres el software sobre el hardware" crlf)
        (assert (perfil SOFTWARE))
    )

    (if (or (and (eq (upcase ?soft) NO) (eq (upcase ?hard) SI)) 
            (and (eq (upcase ?soft) NO) (eq (upcase ?hard) IGUAL)) 
            (and (eq (upcase ?soft) IGUAL) (eq (upcase ?hard) SI))
        ) then
        (printout t "Prefieres el hardware sobre el software" crlf)
        (assert (perfil HARDWARE))
    )

    (if (or (and (eq (upcase ?soft) IGUAL) (eq (upcase ?hard) IGUAL)) 
            (and (eq (upcase ?soft) SI) (eq (upcase ?hard) SI))) then
        (printout t "En principio no tienes ninguna preferencia1" crlf)
        (assert (perfil IGUAL))
    )

    (if (and (eq (upcase ?soft) NO) (eq (upcase ?hard) NO)) then
        (printout t "En principio no tienes ninguna preferencia2" crlf)
        (assert (perfil IGUAL))
    )
)

;;Pregunta sobre si le gusta programar
(defrule gusta_programar
(perfil ?x)
=>  
    (printout t "Vale, " crlf)
    (printout t "Te gusta programar? (SI/NO/IGUAL)" crlf)
    (bind ?ans(read))
    (assert (gusta_programar ?ans))
(assert (Evidencia gusta_programar ?ans))
)
;;Pregunta sobre como de trabajador es
(defrule eres_trabajador
=>
    (printout t "Eres trabajador? (SI/NO/IGUAL)" crlf)
    (bind ?ans(read))
    (assert (es_trabajador ?ans))
(assert (Evidencia es_trabajador ?ans))
)
;;;;; Suponemos que podemos dividir todas las ramas en 2, ramas de software(CSI,SI,IS) y de hard (IC,TIC)
;;Aqui analizamos los datos que tenemos, asigando a datos el pefil y añadiendo informacion sobre si le gusta 
;;programar o como de trabajador es

(defrule first_approach
(declare (salience 5))
(perfil ?perfil)
(gusta_programar ?prog)
(es_trabajador ?trabaja)
(preferencia _ ?text)
=>
    (printout t "Estas tres preguntas que te he hecho sn muy importantes a la hora de tomar la decision" crlf)

    (if (and (eq ?perfil SOFTWARE) (eq (upcase ?prog) SI) ) then
        (assert (preferencia SOFTWARE (str-cat ?text "le gusta el tema software y programar ") ))
        (assert (datos ?perfil PROGRAMA ))
    )
    (if (and (eq ?perfil SOFTWARE) (or (eq (upcase ?prog) NO) (eq (upcase ?prog) IGUAL) ) ) then
        (assert (preferencia SOFTWARE (str-cat ?text " le gusta el tema software pero no mucho programar ")))
        (assert (datos ?perfil NOPROGRAMA ))
    )

    ;:::::::::

    (if (and (eq ?perfil HARDWARE) (eq (upcase ?prog) SI) ) then
        (assert (preferencia HARDWARE (str-cat ?text "le gusta el tema hardware y programar ")))
        (assert (datos ?perfil PROGRAMA ))
    )

    (if (and (eq ?perfil HARDWARE) (or (eq (upcase ?prog) NO) (eq (upcase ?prog) IGUAL) ) ) then
        (assert (preferencia HARDWARE (str-cat ?text " le gusta el tema hardware pero no mucho programar ")))
        (assert (datos ?perfil NOPROGRAMA ))
    )

    (if (and (eq ?perfil IGUAL) (eq (upcase ?prog) SI) ) then
        (assert (preferencia IGUAL (str-cat ?text "no tiene ninguna preferencia pero le gusta programar ")))
        (assert (datos ?perfil PROGRAMA ))
    )

    (if (and (eq ?perfil IGUAL) (or (eq (upcase ?prog) NO) (eq (upcase ?prog) IGUAL) ) ) then
        (assert (preferencia IGUAL (str-cat ?text " no tiene ninguna preferencia pero no mucho programar ")))
        (assert (datos ?perfil NOPROGRAMA ))
    )
    (assert (subrama ?perfil))
)

;;Aqui completamos informacion con como de trabajador es
(defrule first_aproach_2
(declare (salience 4))
(subrama ?perfil)
(datos ?perfil ?prog)
(es_trabajador ?trabaja)
(preferencia ?ALGO ?text)
?f <- (avoid_loop TRUE)
=>
    (if (eq ?perfil SOFTWARE ) then
        (if (eq ?trabaja SI ) then
            (assert (preferencia SOFTWARE (str-cat ?text " es trabajador ")))
            (assert (Datos ?perfil ?prog TRABAJADOR ))
        else
            (assert (preferencia SOFTWARE (str-cat ?text " no es muy trabajador ")))
            (assert (Datos ?perfil ?prog NOTRABAJADOR ))
        )
    )

    (if (eq ?perfil HARDWARE ) then
        (if (eq ?trabaja SI ) then
            (assert (preferencia HARDWARE (str-cat ?text " es trabajador "))) 
            (assert (Datos ?perfil ?prog TRABAJADOR ))
        else
            (assert (preferencia HARDWARE (str-cat ?text " no es muy trabajador ")))
            (assert (Datos ?perfil ?prog NOTRABAJADOR ))
        )
    )
    (if (eq ?perfil IGUAL ) then
        (if (eq ?trabaja SI ) then
            (assert (preferencia IGUAL (str-cat ?text " es trabajador "))) 
            (assert (Datos ?perfil ?prog TRABAJADOR ))
        else
            (assert (preferencia IGUAL (str-cat ?text " no es muy trabajador ")))
            (assert (Datos ?perfil ?prog NOTRABAJADOR ))
        )
    )
    (retract ?f)
)

;;EN Este punto damos un poco de informacion sobre la subrama que podriamos elegir con algun motivo, pero sin 
;;entrar en mucha profundidad
(defrule primer_consejo_soft
  (preferencia ?rama ?texto )
  (descarto Rama ?desc)
  ?f <- (first ?first)
  (test (eq ?rama SOFTWARE))
  (test (eq ?first TRUE))
=>
  (printout t "En principio la rama que mas te recomendaria son las relacionedas con " ?rama "(CSI/SI/IS)  descartando " ?desc crlf)
  (printout t "Motivo: " ?texto "." crlf)
  (retract ?f)
)
;;Igual para las menciones  de hardware
(defrule primer_consejo_hard
  (preferencia ?rama ?texto )
    (descarto Rama ?desc)
    ?f <- (first ?first)
  (test (eq ?rama HARDWARE))
  (test (eq ?first TRUE))
=>
  (printout t "En principio la rama que mas te recomendaria son las relacionedas con " ?rama "(IC / TI) descartando " ?desc crlf)
  (printout t "Motivo: " ?texto "." crlf)
    (retract ?f)
)
;;Igual, segun la info que nos ha dado puede elegir cualquiera en principio
(defrule primer_consejo_igual
  (preferencia ?rama ?texto )
    (descarto Rama ?desc)
    ?f <- (first ?first)
  (test (eq ?rama IGUAL))
  (test (eq ?first TRUE))
=>
  (printout t "En principio cualquier rama es apta para ti menos " ?desc crlf)
  (printout t "Motivo: " ?texto "." crlf)
    (retract ?f)
)

;;Seguimos haciendo preguntas para dar una respuesta mas concisa.
(defrule gusta_mates
(subrama ?perfil)
=>
(printout t "Te gustan las mates (SI/NO/IGUAL)" crlf)
(bind ?ans(read))
(assert (gusta_mates ?ans))
(assert (Evidencia gusta_mates ?ans))
)

(defrule nota
(subrama ?perfil)
(gusta_mates ?mates)
=>
(printout t "QUE nota media tienes (ALTA/MEDIA/BAJA)" crlf)
(printout t "Siendo alta > 8" crlf)
(printout t "Siendo 5 < media < 8" crlf)
(printout t "Siendo baja < 5" crlf)
(assert (nota_media(read)))
)

;;Aqui analizamos lo que tenemos y elaboramos el consejo de que ramas son mejores con un cierto motivo
(defrule second_approach
(declare (salience 3))
(gusta_mates ?mates)
(nota_media ?nota)
 (preferencia ?rama ?text )

(Datos ?perfil ?prog ?trabajador )

=>  
    (if (eq ?perfil SOFTWARE)  then 
        (if (eq ?prog PROGRAMA) then
            (if (or (eq ?mates SI ) (eq ?mates IGUAL )) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo CSI (str-cat ?text " ademas le gustan las mates y su nota es alta, es optima esta rama para ti")))
                    ;(assert (Consejo IS (str-cat ?text " ademas le guste las mates y es trabajador")))
                else
                    (assert (Consejo SI (str-cat ?text " ademas aunque le guste las  mates su nota no es muy alta y puede no entrar")))
                )
            ;;No te gustan las mates
            else
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo IS (str-cat ?text " no le gustan las mates pero es trabajador")))
                else
                    (assert (Consejo SI (str-cat ?text " no le gustan las mates y tiene una nota relativa, es poco trabajador")))
                )
            )
            ;;No te gusta programar
        else
            (if (eq ?mates SI ) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo TI (str-cat ?text " aunque le gustan las mates no le gusta progamar aunque es trabajador")))
                else
                    (assert (Consejo IC (str-cat ?text " , ya que no te gusta ni programar y sus notas y esfuerzo son mejorables")))
                )
            ;;No te gustan las mates
            else
                (assert (Consejo TI (str-cat ?text " no le gusta demasiado programar ")))
            ) 
        )
    )

    (if (eq ?perfil HARDWARE)  then 
        (if (eq ?prog PROGRAMA) then
            (if (eq ?mates SI ) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo CSI (str-cat ?text "puedo recomendarte esta porque coincide en bastantes cosas")))
                else
                    (assert (Consejo TI (str-cat ?text " es muy afin a ti ya que no es demasiado dificil")))
                )
            ;;No te gustan las mates
            else
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo IS (str-cat ?text " no le gustan las mates pero si programar")))
                else
                    (assert (Consejo TI (str-cat ?text " no se centra en mates")))
                )
            )
            ;;No te gusta programar
        else
            (if (eq ?mates SI ) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo TI (str-cat ?text " aunque le gustan las mates no le gusta progamar")))
                else
                    (assert (Consejo IC (str-cat ?text " , ya que no te gusta ni programar y sus notas y esfuerzo son mejorables")))
                )
            ;;No te gustan las mates
            else
                (assert (Consejo TI (str-cat ?text " no le gusta programar xd")))
            )
        )
    )

    (if (eq ?perfil IGUAL)  then 
        (if (eq ?prog PROGRAMA) then
            (if (eq ?mates SI ) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo CSI (str-cat ?text "imporatnte prefiere programar, coincide es cosas como mates trabajador ")))
                    (assert (Consejo IS (str-cat ?text " ademas le guste las mates y es trabajador")))
                else
                    (assert (Consejo SI (str-cat ?text " ademas aunque le guste las  mates su nota no es muy alta y puede no entrar")))
                )
            ;;No te gustan las mates
            else
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo IS (str-cat ?text " no le gustan las mates")))
                else
                    (assert (Consejo SI (str-cat ?text " no le gustan las mates y tiene una nota relativa")))
                )
            )
            ;;No te gusta programar
        else
            (if (eq ?mates SI ) then
                (if (and (or (eq ?nota ALTA) (eq ?nota MEDIA)) (eq ?trabajador TRABAJADOR)) then
                    (assert (Consejo TI (str-cat ?text " aunque le gustan las mates no le gusta progamar")))
                else
                    (assert (Consejo IC (str-cat ?text " , ya que no te gusta ni programar y sus notas y esfuerzo son mejorables")))
                )
            ;;No te gustan las mates
            else
                (assert (Consejo TI (str-cat ?text " no le gusta programar xd")))
            )
            
        )
    )
    ;(assert (subrama ?perfil))
)



;;Imprimimos por pantalla el consejo con una explicacion y mas o menos todas las cosas que ha ido teniendo 
;;en cuenta para llegar a esa conclusion.
(defrule final_advise
    (declare (salience -3))
  (Consejo ?rama ?explicacion)
  (descarto Rama ?desc)
  (test (neq ?rama ?desc))
  (test (neq ?rama _))

  ;?f <- (final ?final)

  ;(test (eq ?final TRUE))
=>
  (printout t "Rama/s : " ?rama crlf)
  (printout t "Motivo: " ?explicacion "." crlf)
   ; (retract ?f)
)


;; Para esta parte utilizaremos razonamiento basado en  factores de certeza

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
    (FactorCerteza ?h SI ?fc1)
    (FactorCerteza ?h NO ?fc2)
=>
    (assert (Certeza ?h (- ?fc1 ?fc2)))
)

; Si sale CSI, las dos ASIGNATURAS para elegir seran MAC Y MH

(defrule R1_CSI
    
    (FactorCerteza gusta_programar SI ?f1)
    (FactorCerteza gusta_mates NO ?f2)
    (test (and (> ?f1 0) (> ?f2 0)))
    (Consejo ?rama ?explicacion)
    (test (eq ?rama CSI))
=>
    (assert (FactorCerteza MH SI (encadenado (* ?f1 ?f2) 0.9)))
)

(defrule R1_CSI2
    
    (FactorCerteza gusta_programar SI ?f1)
    (FactorCerteza gusta_mates IGUAL ?f2)
    (test (and (> ?f1 0) (> ?f2 0)))
    (Consejo ?rama ?explicacion)
    (test (eq ?rama CSI))
=>
    (assert (FactorCerteza MH SI (encadenado (* ?f1 ?f2) 0.7)))
)

(defrule R2_CSI
    (FactorCerteza gusta_mates SI ?f1)
    (test (> ?f1 0))
    (Consejo ?rama ?explicacion)
    (test (eq ?rama CSI))
=>
    (assert (FactorCerteza MAC SI (encadenado ?f1 0.8)))
)


(defrule R3_CSI
    (FactorCerteza gusta_programar SI ?f1)
    (test (> ?f1 0))
    (Consejo ?rama ?explicacion)
    (test (eq ?rama CSI))
=>
    (assert (FactorCerteza MH SI (encadenado ?f1 0.6)))
)

;;añado una variable inicialmente por defectoa0;;
(defrule default
    (declare (salience 10))
=>
    (assert (hip_max desconocido 0))
)

; Como pide, me quedo con la hipotesis con mayor valor de certeza
; Entonces para cada problema me quedo 
(defrule hipotesis_MH
    ?f <- (FactorCerteza MH SI ?fc1)
    ?g <- (hip_max ?hip ?fc2)
    (test (> ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (hip_max MH ?fc1))
)

(defrule hipoteSIs_MAC
    ?f <- (FactorCerteza MAC SI ?fc1)
    ?g <- (hip_max ?hip ?fc2)
    (test(> ?fc1 ?fc2))
=>
    (retract ?f ?g)
    (assert (hip_max MAC ?fc1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule decision_MH
(declare (salience -4))
?f <- (hip_max ?hip ?fc)
(test (and (> ?fc 0) (eq ?hip MH)))
=>
(retract ?f)
(assert (hipotesis_final " es preferible elegir MH" ?fc))
)

(defrule decision_MAC
(declare (salience -4))
?f <-(hip_max ?hip ?fc)
(test (and (> ?fc 0) (eq ?hip MAC)))
=>
(retract ?f)
(assert (hipotesis_final " es preferible elegir MAC" ?fc))
)

(defrule decision_final
(declare (salience -5))
(hipotesis_final ?hip ?fc)
(test (> ?fc 0))
=>
(printout t "Deducimos a un " (* ?fc 100) "% de certeza que  " ?hip " dada la informacion anteriormene citada "crlf)
)