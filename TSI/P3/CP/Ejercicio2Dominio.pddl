(define (domain ejercicio2)

    (:requirements :strips :adl)

    (:types
        entidad localizacion recurso - object
        unidad edificio - entidad

        tipoUnidad - unidad
        tipoEdificio - edificio
        tipoRecurso - recurso
    )

    (:constants
        VCE - tipoUnidad
        CentroDeMando Barracones Extractor - tipoEdificio
        Mineral Gas - tipoRecurso
    )

    (:predicates
        (en ?obj - entidad ?x - localizacion)
        (existeCamino ?x - localizacion ?y - localizacion)
        (edificioConstruido ?e - edificio)
        (asignarNodo ?r - recurso ?x - localizacion)
        (extrayendo ?r - recurso)
        (esTipoUnidad ?u - unidad ?tu - tipoUnidad)
        (esTipoEdificio ?e - edificio ?te - tipoEdificio)
        (libre ?u - unidad)
        (recursosNecesarios ?te - tipoEdificio ?tr - tipoRecurso)
    )

    ;Acciones
    (:action Navegar
        :parameters (?u - unidad ?x ?y - localizacion)
        :precondition (and
            (en ?u ?x)
            (existeCamino ?x ?y)
        )
        :effect (and
            (en ?u ?y)
            (not (en ?u ?x))
        )
    )

    (:action Asignar
        :parameters (?u - unidad ?x - localizacion ?r - recurso)
        :precondition (and
            (en ?u ?x)
            (asignarNodo ?r ?x)
            (libre ?u)

            (or
                (exists (?e - edificio)
                    (and
                        (en ?e ?x)
                        (esTipoEdificio ?e Extractor)
                    )
                )
                (not (asignarNodo Gas ?x))
            )
        )
        :effect (and
            (extrayendo ?r)
            (not (libre ?u))
        )
    )

    (:action Construir
        :parameters (?u - unidad ?e - edificio ?x - localizacion ?r - recurso)
        :precondition (and
            (libre ?u)
            (en ?u ?x)
            (exists (?te - tipoEdificio)
                (and
                    (esTipoEdificio ?e ?te)
                    (recursosNecesarios ?e ?r)
                    (extrayendo ?r)
                )
            )

        )
        :effect (and
            (edificioConstruido ?e)
            (en ?e ?x)
        )
    )

)