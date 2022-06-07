(define (problem ejercicio1) 
    (:domain ejercicio1)
    (:objects 
        ; Unidades
        VCE1 - unidad

        ; Edificios
        CentroDeMando1 - edificio
        
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

        ; Asignamos la localizacion de las unidades
        (unidadEn VCE1 LOC11)

        ; Asignamos la localizacion de los recursos
        (depositoEn Mineral LOC22)
        (depositoEn Mineral LOC32)

        ; Tipos de los edificios
        (edificioEs CentroDeMando1 CentroDeMando)

        ; Tipos de las unidades
        (unidadEs VCE1 VCE)

        ; Unidades libres
        (libre VCE1)
    )
    (:goal 
        (recursoDisp Mineral)  
    )
)