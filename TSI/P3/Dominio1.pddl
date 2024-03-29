(define (domain ejercicio1)
    (:requirements :strips :typing :adl)
    (:types
		; Necesitamos crear los tipos:
        tipoUnidad tipoEdificio entidad localizacion recurso - object
		; Tipos de entidades
        unidad edificio - entidad
    )

    (:constants
        VCE - tipoUnidad
        CentroDeMando Barracones - tipoEdificio
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
    )

    ; Mover a una unidad entre dos localizaciones
    (:action navegar
        :parameters (?uni - unidad ?locOri ?locDest - localizacion)
        :precondition 
            (and 
                ; Solo podemos mover unidades si estan libres
                (libre ?uni)
                ; La unidad tiene que estar en la localiacion de origen
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
)