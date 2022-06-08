(define (problem ejercicio6)
    (:domain ejercicio6)
    (:objects
        VCE1 VCE2 VCE3 Soldado1 Marine1 Marine2 - tipoUnidad
        CentroDeMando1 Extractor1 Barracones1 BahiaDeIngenieria1 - tipoEdificio
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC44 - localizacion
        Investigacion1 - tipoInvestigacion
    )

    (:init
        (existeCamino LOC11 LOC12)
        (existeCamino LOC11 LOC21)

        (existeCamino LOC12 LOC11)
        (existeCamino LOC12 LOC22)

        (existeCamino LOC13 LOC14)
        (existeCamino LOC13 LOC23)

        (existeCamino LOC14 LOC13)
        (existeCamino LOC14 LOC24)

        (existeCamino LOC21 LOC11)
        (existeCamino LOC21 LOC31)

        (existeCamino LOC22 LOC12)
        (existeCamino LOC22 LOC23)
        (existeCamino LOC22 LOC32)

        (existeCamino LOC23 LOC13)
        (existeCamino LOC23 LOC22)
        (existeCamino LOC23 LOC33)

        (existeCamino LOC24 LOC14)
        (existeCamino LOC24 LOC34)

        (existeCamino LOC31 LOC21)
        (existeCamino LOC31 LOC32)

        (existeCamino LOC32 LOC22)
        (existeCamino LOC32 LOC31)

        (existeCamino LOC33 LOC23)
        (existeCamino LOC33 LOC34)

        (existeCamino LOC34 LOC24)
        (existeCamino LOC34 LOC33)
        (existeCamino LOC34 LOC44)

        (existeCamino LOC44 LOC34)

        (esTipoUnidad VCE1 VCE)
        (esTipoUnidad VCE2 VCE)
        (esTipoUnidad VCE3 VCE)

        (esTipoUnidad Soldado1 Soldado)

        (esTipoUnidad Marine1 Marine)
        (esTipoUnidad Marine2 Marine)

        (esTipoEdificio CentroDeMando1 CentroDeMando)
        (esTipoEdificio Extractor1 Extractor)
        (esTipoEdificio Barracones1 Barracones)
        (esTipoEdificio BahiaDeIngenieria1 BahiaDeIngenieria)

        (esTipoInvestivacion Investigacion1 SoldadoUniversal)

        (recursosNecesarios Extractor1 Mineral)
        (recursosNecesarios Barracones1 Mineral)
        (recursosNecesarios Barracones1 Gas)
        (recursosNecesarios BahiaDeIngenieria1 Mineral)
        (recursosNecesarios BahiaDeIngenieria1 Gas)

        (recursosNecesarios Soldado1 Mineral)
        (recursosNecesarios Soldado1 Gas)
        (recursosNecesarios Marine1 Mineral)
        (recursosNecesarios Marine2 Mineral)

        (recursosNecesarios Investigacion1 Mineral)
        (recursosNecesarios Investigacion1 Gas)

        (en VCE1 LOC11)
        
        (libre VCE1)

        (en CentroDeMando1 LOC11)
        (edificioConstruido CentroDeMando1)

        (asignarNodo Mineral LOC22)
        (asignarNodo Mineral LOC32)
        (asignarNodo Gas LOC44)

        (= (coste) 0)
    )

    (:goal
        (and
            (en Marine1 LOC14)
            (en Marine2 LOC14)
            (en Soldado1 LOC14)
            (en Barracones1 LOC14)
            (en BahiaDeIngenieria1 LOC12)
            (< (coste) 29)
        )
    )
)