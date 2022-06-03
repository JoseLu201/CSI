(define (problem ejercicio6) 
    (:domain ejercicio6)
    (:objects 
        ; Añadimos las nuevas unidades
        VCE1 VCE2 VCE3 - unidad
        Marine1 Marine2 Soldado1 - unidad


        ; Añado la bahia de ingenieria
        CentroDeMando1 Extractor1 Barracones1 BahiaDeIngenieria1 - edificio
        
        ; Localizaciones
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC44 - localizacion
    )
    (:init
        ; Caminos
        ;   LOC11
        (camino LOC11 LOC12)
        (camino LOC11 LOC21)
        ;   LOC12
        (camino LOC12 LOC11)
        (camino LOC12 LOC22)
        ;   LOC13
        (camino LOC13 LOC14)
        (camino LOC13 LOC23)
        ;   LOC14
        (camino LOC14 LOC13)
        (camino LOC14 LOC24)
        ;   LOC21
        (camino LOC21 LOC11)
        (camino LOC21 LOC31)
        ;   LOC22
        (camino LOC22 LOC12)
        (camino LOC22 LOC32)
        (camino LOC22 LOC23)
        ;   LOC23
        (camino LOC23 LOC22)
        (camino LOC23 LOC13)
		(camino LOC23 LOC33)
        ;   LOC24
        (camino LOC24 LOC14)
        (camino LOC24 LOC34)
        ;   LOC31
        (camino LOC31 LOC21)
        (camino LOC31 LOC32)
        ;   LOC32
        (camino LOC32 LOC22)
        (camino LOC32 LOC31)
        ;   LOC33
        (camino LOC33 LOC23)
        (camino LOC33 LOC34)
		;   LOC34
        (camino LOC34 LOC24)
        (camino LOC34 LOC33)
		(camino LOC34 LOC44)
		;	LOC44
		(camino LOC44 LOC34)

        ; Asignamos la localizacion de los edificios
        (edificioEn CentroDeMando1 LOC11)
        
        ;(construccion CentroDeMando1 LOC11)
        (locOcupada LOC11)

        ; Asignamos la localizacion de las unidades
        (unidadEn VCE1 LOC11)
        ;;(unidadEn VCE2 LOC11)
        ;;(unidadEn VCE3 LOC11)
        
        ; Asignamos la localizacion de los recursos
        (depositoEn Mineral LOC22)
        (depositoEn Mineral LOC32)
        (depositoEn GasVespeno LOC44)

        ; Definimos los tipos de los edificios
        (edificioEs CentroDeMando1 CentroDeMando)
        (edificioEs Extractor1 Extractor)
        (edificioEs Barracones1 Barracones)
        (edificioEs BahiaDeIngenieria1 BahiaDeIngenieria)

        ;  Definimos los tipos de las unidades
        (unidadEs VCE1 VCE)
        (unidadEs VCE2 VCE)
        (unidadEs VCE3 VCE)
        
        ; Añadimos las nuevas unidades 
        (unidadEs Marine1 Marine)
        (unidadEs Marine2 Marine)
        (unidadEs Soldado1 Soldado)

        ; Unidades libres
        (libre VCE1)

        ; En un principio ya tenemos a una unidad reclutada
        (uniReclutada VCE1)

        ; Centro de mando ya contruido
        (construido CentroDeMando1)

        ; Necesitamos ciertos recursos para la contruccion.
        (edificioRequiere Extractor Mineral)

        (edificioRequiere Barracones Mineral)
        (edificioRequiere Barracones GasVespeno)

        ; Para contruir la BAHIA DE INGENIERIA necsitamos
        (edificioRequiere BahiaDeIngenieria Mineral)
        (edificioRequiere BahiaDeIngenieria GasVespeno)

        ; Recursos que necesitamos para el reclutamiento de cada uniadad
        (unidadRequiereRecu VCE Mineral)
        (unidadRequiereRecu Marine Mineral)
        ; Los soldados necesitan ambos recursos
        (unidadRequiereRecu Soldado Mineral)
        (unidadRequiereRecu Soldado GasVespeno)

        ; Edificio requerido por una unidad para su reclutamiento
        (unidadRequiereEdi VCE CentroDeMando)
        (unidadRequiereEdi Marine Barracones)
        (unidadRequiereEdi Soldado Barracones)

        ; Para crear el soldado necesitamos investigacion
        (uniNecesitaInv Soldado SoldadoUniv)

        (invRequiereRecu SoldadoUniv Mineral)
        (invRequiereRecu SoldadoUniv GasVespeno)

        (= (coste) 0)

    )
    (:goal 
        (and
            ; Necesitamos contruir los barracones para poder generar tropas.
            (edificioEn Barracones1 LOC14)
            (unidadEn Marine1 LOC14)
            (unidadEn Marine2 LOC14)
            (unidadEn Soldado1 LOC14)
            (edificioEn BahiaDeIngenieria1 LOC12)
            
            ; Si ponemos 24 obtenemos best first search space empty! problem proven unsolvable.
            (< (coste) 25) ; 
        )
    )
)
