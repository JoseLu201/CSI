(define (domain ejercicio1)

    (:requirements :strips)

    (:types
        entidad localizacion recurso - object
        unidad edificio - entidad

        tipoUnidad - unidad
        tipoEdificio - edificio
        tipoRecurso - recurso
    )

    (:constants
        VCE - tipoUnidad
        CentroDeMando Barracones - tipoEdificio
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
        )
        :effect (and
            (extrayendo ?r)
            (not (libre ?u))
        )
    )  
)