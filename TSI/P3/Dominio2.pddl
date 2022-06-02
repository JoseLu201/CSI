(define (domain ejercicio2)
    (:requirements :strips :typing :adl)
    (:types
		; Necesitamos crear los tipos:
        tipoUnidad tipoEdificio entidad localizacion recurso - object
		; Tipos de entidades
        unidad edificio - entidad
    )

    (:constants
        VCE - tipoUnidad
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
        (edificioRequiere ?tipoEdi - tipoEdificio ?recu - recurso)

        ; Comprobar que tenemos el recurso
        (recursoDisp ?recu - recurso)

        ; Determima si el edificio esta contruido
        (construido ?e - edificio)

        ; La localizacion no puede estar ocuapada
        (locOcupada ?loc - localizacion)
    
        ; Cuando contruirmos un edifico de cualqiuer tipo
        (construccion ?e - tipoEdificio ?loc - localizacion)
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
                ; La unidad tiene que ser del tipo VCE
                (unidadEs ?uni VCE)
                ; En la localizacion del recurso tiene que haber un recurso
                (depositoEn ?recu ?loc)
                ; La unidad ?uni se encuentra en la localización de extracción ?loc
                (unidadEn ?uni ?loc)

                (or
                    ; Hay un deposito de mineral en la loc
                    (depositoEn Mineral ?loc)
                    (construccion Extractor ?loc)
                )
            )
        :effect 
            (and 
                ; Cuando hay un depósito de Gas vespeno en la localizacion
                (when (depositoEn GasVespeno ?loc) 
                    ; Se dispone del recurso Gas Vespeno
                    (disponibleRecu GasVespeno)
                )
                ; Cuando hay un depósito de Mineral en la localizacion 
                (when (depositoEn Mineral ?loc) 
                    ; Se dispone del recurso Mineral
                    (disponibleRecu Mineral)
                )
                ; Cambiamos la disponibilidad de la unidad
                (not (libre ?uni))
            )
    )

    (:action construir
        :parameters (?uni - unidad ?e - edificio ?loc - localizacion ?recu - recurso)
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
                    (not (edificioEs ?e Extractor))
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
)
