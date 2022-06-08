(define (domain ejercicio6)

    (:requirements :strips :adl :fluents)

    (:types
        entidad localizacion recurso - object
        unidad edificio investigacion - entidad

        tipoUnidad - unidad
        tipoEdificio - edificio
        tipoRecurso - recurso
        tipoInvestigacion - investigacion
    )

    (:constants
        VCE Marine Soldado - tipoUnidad
        CentroDeMando Barracones Extractor BahiaDeIngenieria - tipoEdificio
        Mineral Gas - tipoRecurso
        SoldadoUniversal - tipoInvestigacion
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
        (recursosNecesarios ?e - entidad ?tr - tipoRecurso)
        (esTipoInvestivacion ?i - investigacion ?ti - tipoInvestigacion)
        (investigacionRealizada ?i - investigacion)
    )

    (:functions
        (coste)
    )

    ;Acciones
    (:action Navegar
        :parameters (?u - unidad ?x ?y - localizacion)
        :precondition (and
            (en ?u ?x)
            (existeCamino ?x ?y)
            (libre ?u)
        )
        :effect (and
            (en ?u ?y)
            (not (en ?u ?x))
            (increase (coste) 1)
        )
    )

    (:action Asignar
        :parameters (?u - unidad ?x - localizacion ?r - recurso)
        :precondition (and
            (en ?u ?x)
            (asignarNodo ?r ?x)
            (libre ?u)

            (or
                (exists
                    (?e - edificio)
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
            (increase (coste) 1)
        )
    )

    (:action Construir
        :parameters (?u - unidad ?e - edificio ?x - localizacion)
        :precondition (and
            (libre ?u)
            (en ?u ?x)
            (not (edificioConstruido ?e))
            (not (exists
                    (?e - edificio)
                    (en ?e ?x))
            )

            (forall
                (?tr - tipoRecurso)
                (exists
                    (?te - tipoEdificio)
                    (and
                        (esTipoEdificio ?e ?te)

                        (imply
                            (recursosNecesarios ?e ?tr)
                            (extrayendo ?tr)
                        )
                    )
                )
            )

        )
        :effect (and
            (edificioConstruido ?e)
            (en ?e ?x)
            (increase (coste) 1)
        )
    )

    (:action Reclutar
        :parameters (?e - edificio ?u - unidad ?x - localizacion)
        :precondition (and
            (not (exists(?loc - localizacion)
                    (and
                        (en ?u ?loc)
                    )
                )
            )

            (en ?e ?x)

            (imply
                (or
                    (esTipoUnidad ?u VCE)
                    (esTipoUnidad ?u Marine)
                )
                (extrayendo Mineral)
            )

            (imply (esTipoUnidad ?u Soldado)
                (and
                    (extrayendo Mineral)
                    (extrayendo Gas)
                    (investigacionRealizada SoldadoUniversal)
                )
            )

            (imply (esTipoEdificio ?e CentroDeMando)
                (esTipoUnidad ?u VCE)
            )

            (imply (esTipoEdificio ?e Barracones)
                (or
                    (esTipoUnidad ?u Marine)
                    (esTipoUnidad ?u Soldado)
                )
            )          
        )
        :effect (and
            (en ?u ?x)
            (libre ?u)
            (increase (coste) 1)
        )
    )

    (:action Investigar
        :parameters (?e - edificio ?i - investigacion)
        :precondition (and
            (not (investigacionRealizada ?i))
            (esTipoEdificio ?e BahiaDeIngenieria)
            (edificioConstruido ?e)
            (imply (esTipoInvestivacion ?i SoldadoUniversal)
                (and
                    (extrayendo Mineral)
                    (extrayendo Gas)
                )
            )

        )
        :effect (and
            (investigacionRealizada ?i)
            (increase (coste) 1)
        )
    )
    
)