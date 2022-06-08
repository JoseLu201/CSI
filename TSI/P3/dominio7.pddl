(define (domain ejercicio7)
    (:requirements :strips :typing :adl :fluents)
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
        
		; Determina la localizacion de un recurso
        (depositoEn ?recu - recurso ?loc - localizacion)
        
		; Determina la disopnibilidad de dicho recurso
        (recursoDisp ?recu - recurso)
        
		; Determina que dicha unidad esta libre
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

       
        ; Cada unidad requiere de ciertos edificios
        (unidadRequiereEdi ?tipo - tipoUnidad ?edi - tipoEdificio)

        (extrayendo ?r - recurso)
    )

    (:functions
        ; Cantidad del recurso (almacen)
        (cantidad ?r - recurso)
        ; Cantidad de recursos que cada VCE puede recolectar
        (cantidadRecoleccionVCE)
        

        ;Como cada unidad/edificio requiere de cierta cantidad de materiales
        (unidadRequiereRecu ?tipo - tipoUnidad ?recu - recurso)
        (edificioRequiere ?edi - tipoEdificio ?recu - recurso)
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

    ; Asigna una unidad a una localizacion
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
               ; La unidad tiene que estar en la localizacion para extraer el recurso
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
                 ;Cuando hay un depósito de Gas vespeno en loc
                (when (depositoEn GasVespeno ?loc) 
                    ; Tenemos ese recurso
                    (recursoDisp GasVespeno)
                )
                ; Cuando hay un depósito de Mineral en loc
                (when (depositoEn Mineral ?loc) 
                    ; Tenemos ese recurso
                    (recursoDisp Mineral)
                )
                ; Cambiamos la disponibilidad de la unidad
                (not (libre ?uni))
                (extrayendo ?recu)
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

                        (>= (cantidad Mineral) (edificioRequiere ?tE Mineral) )
                        (>= (cantidad GasVespeno) (edificioRequiere ?tE GasVespeno) )
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
                    (and
                        (decrease (cantidad Mineral) (edificioRequiere Barracones Mineral))
                        (decrease (cantidad GasVespeno) (edificioRequiere Barracones GasVespeno))
                        (construccion Barracones ?loc)
                    )
                )   
                
                (when (edificioEs ?e Extractor )
                    (and
                        (decrease (cantidad Mineral) (edificioRequiere Extractor Mineral))
                        (decrease (cantidad GasVespeno) (edificioRequiere Extractor GasVespeno))
                        (construccion Extractor ?loc)
                    )
                )
            )
    )


    ; Reclutar una unidad
    (:action reclutar
        :parameters (?e - edificio ?uni - unidad ?loc - localizacion)
        :precondition 
            (and 
                ; La unidad no esta reclutada
                (not (uniReclutada ?uni))
                (exists (?tU - tipoUnidad ?tE - tipoEdificio)
                    (and
                        ; La unidad es de ese tipo
                        (unidadEs ?uni ?tU)
                        (>= (cantidad Mineral) (unidadRequiereRecu ?tU Mineral))
                        (>= (cantidad GasVespeno) (unidadRequiereRecu ?tU GasVespeno))

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

                (when (unidadEs ?uni VCE) 
                    (and
                        ; Decrementar la cantidad de recursos de Mineral quitando la cantidad requerida por el VCE
                        (decrease (cantidad Mineral) (unidadRequiereRecu VCE Mineral))
                        ; Decrementar la cantidad de recursos de Gas vespeno quitando la cantidad requerida por el VCE
                        (decrease (cantidad GasVespeno) (unidadRequiereRecu VCE GasVespeno))
                    )
                )
                ; Cuando la unidad es un Marine
                (when (unidadEs ?uni Marine) 
                    (and
                        ; Decrementar la cantidad de recursos de Mineral quitando la cantidad requerida por el Marine
                        (decrease (cantidad Mineral) (unidadRequiereRecu Marine Mineral))
                        ; Decrementar la cantidad de recursos de Gas vespeno quitando la cantidad requerida por el Marine
                        (decrease (cantidad GasVespeno) (unidadRequiereRecu Marine GasVespeno))
                    )
                )
                ; Cuando la unidad es un Soladado
                (when (unidadEs ?uni Soldado) 
                    (and
                        ; Decrementar la cantidad de recursos de Mineral quitando la cantidad requerida por el Soldado
                        (decrease (cantidad Mineral) (unidadRequiereRecu Soldado Mineral))
                        ; Decrementar la cantidad de recursos de Gas vespeno quitando la cantidad requerida por el Soldado
                        (decrease (cantidad GasVespeno) (unidadRequiereRecu Soldado GasVespeno))
                    )
                )
            )
    )

    ; Recolectar los recursos de una localización
    (:action recolectar
        :parameters (?r - recurso ?loc - localizacion)
        :precondition 
            (and 
                ; Tenemos recursos en la loc
                (depositoEn ?r ?loc)
                ; Tenemos una unidad en esa localizacion
                (exists (?uni - unidad) 
                    (unidadEn ?uni ?loc)
                )
                (extrayendo ?r)
                    
                
                ; Definimos el maximo de almacenamiento
                (<=
                    (+ (cantidad ?r) (cantidadRecoleccionVCE) )
                    60
                )
            )
        :effect 
            ; Aumentamos los recuros recolectados
            (increase (cantidad ?r) (cantidadRecoleccionVCE))
    )
)
