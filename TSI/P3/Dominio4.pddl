(define (domain ejercicio4)
    (:requirements :strips :typing :adl)
    (:types
		; Necesitamos crear los tipos:
        tipoUnidad tipoEdificio entidad localizacion recurso - object
		; Tipos de entidades
        unidad edificio - entidad
    )

    (:constants
        VCE Marine Soldado - tipoUnidad
        ; Añadimos el tipo de extractor
        CentroDeMando Barracones Extractor - tipoEdificio
        Mineral GasVespeno - recurso
    )
    (:predicates
		; Determinar si un edificio esta en una localizacion.
        (edificioEn ?e - edificio ?loc - localizacion)

        ; Determinar el tipo de edificio
        (edificioEs ?e - edificio ?tipo - tipoEdificio)
        ; Igual para unidades
		; Determinar el tipo de unidades ()
        (unidadEs ?uni - unidad ?tipo - tipoUnidad)
        
		; Determinar la localizacion de una unidad
        (unidadEn ?uni - unidad ?loc - localizacion)
        
		; Determinar si existe un camino de la localizacion origen hasta la destino
        (camino ?locOri - localizacion ?locDest - localizacion)
        
		; Un depósito del recurso ?recu se encuentra en la localización ?loc
        (depositoEn ?recu - recurso ?loc - localizacion)
        
		; Se dispone del recurso ?recu
        (disponibleRecu ?recu - recurso)
        
		; La unidad ?uni está libre
        (libre ?uni - unidad)
        ;;;;;;;;;;;;

        ; Necesitamos recursos para contruir el edificio
        (edificioRequiere ?edi - tipoEdificio ?recu - recurso)

        ; Determima si el edificio esta contruido
        (construido ?e - edificio)

        ; La localizacion no puede estar ocuapada
        (locOcupada ?loc - localizacion)
    
        ; Cuando contruirmos un edifico de cualqiuer tipo
        (construccion ?edi - tipoEdificio ?loc - localizacion)

        ; Unidad reclutada

        (uniReclutada ?uni - unidad)

        (unidadRequiereRecu ?tipo - tipoUnidad ?recu - recurso)
        ; El tipo de unidad ?tipoUni requiere tener el tipo de edificio ?tipoEdi para poder reclutarla
        (unidadRequiereEdi ?tipo - tipoUnidad ?edi - tipoEdificio)

    )

    ; Mover a una unidad entre dos localizaciones
    (:action navegar
        :parameters (?uni - unidad ?locOri ?locDest - localizacion)
        :precondition 
            (and 
                ; Solo podemos mover unidades si estan libres
                (libre ?uni)
                ; La unidad tiene que estar en la localizacion de origen
                (unidadEn ?uni ?locOri)
                ; Existe un camino entre ambas localizaciones
                (camino ?locOri ?locDest)
            )
        :effect 
            (and 
                ; Movemos la unidad a la localizacion destino
                (unidadEn ?uni ?locDest)
                ; y la quitamos en la localizacion de origen
                (not (unidadEn ?uni ?locOri))
            )
    )

    ; Asignar un VCE a un nodo de recursos.
    (:action asignar
        :parameters (?uni - unidad ?loc - localizacion ?recu - recurso)
        :precondition 
            (and 
                ; Solo podemos asignar unidades si estan libres
                (libre ?uni)
                ; La unidad tiene que ser del tipo VCE para ser asignada
                (unidadEs ?uni VCE)
                ; En la localizacion del recurso tiene que haber un recurso
                (depositoEn ?recu ?loc)
                ; La unidad ?uni se encuentra en la localización de extracción ?loc
                (unidadEn ?uni ?loc)

                (or
                    ; Hay un deposito de mineral en la loc
                    (depositoEn Mineral ?loc)
                    ; Asignamos que hay una edificio en esa localizacion 
                    (construccion Extractor ?loc)
                )
            )
        :effect 
            (and 
                ; Cuando hay un depósito de Gas vespeno en loc
                (when (depositoEn GasVespeno ?loc) 
                    ; Tenemos ese recurso
                    (disponibleRecu GasVespeno)
                )
                ; Cuando hay un depósito de Mineral en loc
                (when (depositoEn Mineral ?loc) 
                    ; Tenemos ese recurso
                    (disponibleRecu Mineral)
                )
                ; Cambiamos la disponibilidad de la unidad
                (not (libre ?uni))
            )
    )

    ; Cambiamos el contruircor para añadir la necesidad de los materiales
    (:action construir
        :parameters (?uni - unidad ?e - edificio ?loc - localizacion)
        :precondition 
            (and 
                ; El edificio no puede estar previamente contruido
                (not (construido ?e))

                ; Tampoco puede estar la localizacion ocupada
                (not (locOcupada ?loc))
                ; Unidad Libre
                (libre ?uni)
                ;La unidad VCE esta en la localizacion para contruir
                (unidadEs ?uni VCE)
                (unidadEn ?uni ?loc)

                ; Si lo que contruirmos es un extracor
                (or
                    (and
                        (edificioEs ?e Extractor)
                        ; y hay un recurso de gas
                        (depositoEn GasVespeno ?loc)
                    )
                    ; Para el caso de que no el edificio no sea un extractor
                    (not (edificioEs ?e Extractor))
                )
                ; Tenemos 3 tipos de casos, en los que el edificio necesita:
                ;   -> solo mineral
                ;   -> solo gas
                ;   -> ambos
                ; Por lo que necesitaremos disponibilidad de esos recursos para cada contruiccion
                (exists (?tE - tipoEdificio)
                    (and
                        (edificioEs ?e ?tE)
                        (or
                            (and
                                (edificioRequiere ?tE Mineral)
                                (not (edificioRequiere ?tE GasVespeno))
                                (disponibleRecu Mineral)
                            )
                            (and
                                (edificioRequiere ?tE GasVespeno)
                                (not (edificioRequiere ?tE Mineral))
                                (disponibleRecu GasVespeno)
                            )
                            (and
                                (edificioRequiere ?tE Mineral)
                                (edificioRequiere ?tE GasVespeno)
                                (disponibleRecu Mineral)
                                (disponibleRecu GasVespeno)
                            )
                        )
                    )
                )
            )
        :effect 
            (and 
                ; Asertamos que hay un edificio CONSTRUIDO  en la nueva localizacion
                (edificioEn ?e ?loc)
                (construido ?e)
                ; por lo que la localiacion estara ocupada ahora
                (locOcupada ?loc)

                ;Dependiendo de lo que hemos contruido asertamos el tipo de edificio
                (when (edificioEs ?e Barracones )
                    (construccion Barracones ?loc)
                )   
                
                (when (edificioEs ?e Extractor )
                    (construccion Extractor ?loc)
                )
            )
    )


    ; Reclutar una unidad
    (:action reclutar
        :parameters (?e - edificio ?uni - unidad ?loc - localizacion)
        :precondition 
            (and 
                ; La unidad ?uni todavía no ha sido reclutada
                (not (uniReclutada ?uni))
                (exists (?tU - tipoUnidad ?tE - tipoEdificio)
                    (and
                        ; La unidad ?uni es de tipo ?tipoUni
                        (unidadEs ?uni ?tU)
                        (or
                            (and
                                ; Tenemos una unidad que necesita SOLAMENTE mineral para ser contruida, necesitamos
                                ; ese material
                                (unidadRequiereRecu ?tU Mineral)
                                ; por lo que no necesitams gas
                                (not (unidadRequiereRecu ?tU GasVespeno))
                                (disponibleRecu Mineral)
                            )
                            (and
                                ; Tenemos una unidad que necesita SOLAMENTE gas para ser contruida, necesitamos
                                ; ese material
                                (unidadRequiereRecu ?tU GasVespeno)
                                ; por lo que no necesitams mineral
                                (not (unidadRequiereRecu ?tU Mineral))

                                (disponibleRecu GasVespeno)
                            )
                            (and
                                ; Tenemos una unidad que necesita tanto gas como mineral para ser contruida, necesitamos
                                ; ambos materiales
                                (unidadRequiereRecu ?tU GasVespeno)
                                (unidadRequiereRecu ?tU Mineral)

                                (disponibleRecu Mineral)
                                (disponibleRecu GasVespeno)
                            )
                        )
                        
                        ; Cada unidad requiere de untipo de edificio
                        (edificioEs ?e ?tE)
                        (unidadRequiereEdi ?tU ?tE)

                        (edificioEn ?e ?loc)
                    )
                )
            )
        :effect 
            (and 
                ; Cuando reclutamos esa unidad, al principio esta libre
                (libre ?uni)
                ; Marcamos la unidad como ya reclutada
                (uniReclutada ?uni)
                ; en una posicion
                (unidadEn ?uni ?loc)
            )
    )
)
