(deffacts datos
(ave gorrion) (ave paloma) (ave aguila) (ave pinguino)
(mamifero vaca) (mamifero perro) (mamifero caballo)
(vuela pinguino no seguro))

;;;Pregunta el animal que le interesa saber si vuela o no vuela ;
(defrule pregunta
(declare (salience -3))
=>
(printout t "Que animal te gustaria saber si vuela o no? ")
(assert (animal_nuevo (read)))
(assert (animal_insertado desconocido))
)

(defrule conoce_animal
	(declare (salience-4))
	?f<-(animal_nuevo ?x)
	(animal ?x)
	(explicacion animal ?x ?expl1)
	(explicacion vuela ?x Pexpl2)
	=>
	(retract ?f)
	(printout t ?expl1 crlf)
	(printout t 2expl2 crlf)
)

(defrule no_conoce animal
	(declare (salience-4))
	?f<-(animal_nuevo ?x)
	=>
	(printoutt "El animal " ?x " es un ave o un mamifero? (ave, mamifero o nolose) ")
	(assert (animalEs ?x (read)))
	(retract ?f)
)

(defrule add_mamifero
	(declare (salience-4))
	(animalEs ?x ?y)
	(test (eq mamifero ?y))
	(assert (mamifero ?x))
)

(defrule add_ave
	(declare (salience -4))
	(animalEs ?x ?y)
	(test (eq ave ?y))
	(assert (ave ?x))
)

(defrule add_nolose
(declare (salience-4))
(animalEs ?x ?y)
(test (eq nolose ?y))
(assert (animal ?x))
)

(defrule conocimiento_nuevo_animal
(declare (salience-5))
?f-(animalEs ?x ?y)
(animal ?x)
(explicacion vuela ?x ?expl2)
(test (eq nolose ?y))
=>
(retract ?f)
(printout t ?expl2 crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
;Las aves son animales
(defrule aves_son_animales
	(ave ?x)
	=>
	(assert (animal ?x))
	(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son un tipo de animal"))
	(assert (explicacion animal ?x ?expl))
)

(defrule mamiferos_son_animales
(mamifero ?x)
(assert (animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque los mamiferos son un tipo de animal"))
(assert (explicacion animal ?x ?expl) )
)

(defrule ave_vuela_por_defecto
(declare (salience -1)); para disminuir probabilidad de añadir erróneamente
(ave ?x)
=>
(assert(vuela ?x si por_defecto))
(bind Pexpl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan"))
(assert (explicacion vuela ?x ?expl))
)

;Retractamos cuando hay algo en contra
(defrule retracta_vuela_por_defecto
(declare (salience 1)); para retractar antes de inferir cosas erroneamente
?f<-(vuela ?x ?r por_defecto)
(vuela ?x ?s seguro)
=>
(retract ?f)
(bind ?expl (str-cat "retractamos que un " ?x ?r" vuela por defecto, porque sabemos
seguro que " ?x ?s " vuela"))
(assert(explicacion retracta_vuela ?x ?expl))
)

(defrule mayor_parte_animales_no_vuelan
(declare (salience -2))
(animal ?x)
(not (vuela ?x ? ?))
=>
(assert (vuela ?x no por_defecto))
(bind ?expl (str-cat "asumo que" ?x" no vuela, porque la mayor parte de los animales no vuelan"))
(assert (explicacion vuela ?x ?expl))
)
