global combinarImagenes_asm


section .rodata
align 16

correcionSigno: times 4 db 0x80, 0x80, 0x80, 0
resB: db 2, 0xFF , 0xFF, 0xFF, 6, 0xFF, 0xFF, 0xFF, 10, 0xFF, 0xFF, 0xFF, 14, 0xFF, 0xFF, 0xFF
resR: db 0xFF, 0xFF, 0, 0xFF, 0xFF, 0xFF, 4, 0xFF, 0xFF, 0xFF, 8, 0xFF, 0xFF, 0xFF, 12, 0xFF
resG: db  0xFF, 1, 0xFF, 0xFF,0xFF, 5, 0xFF, 0xFF,0xFF, 9, 0xFF, 0xFF,0xFF, 13, 0xFF, 0xFF
;########### SECCION DE TEXTO (PROGRAMA)
section .text

combinarImagenes_asm:
    push rbp
    mov rbp, rsp

    ; Calculo los pixeles totales

    xor r9, r9

    .siguienteFila:
        add r9, rcx ; Sumo los pixeles de la fila
        dec r8
        cmp r8, 0
        jne .siguienteFila

    ;rdi = uint8_t *src_a 
    ;rsi = uint8_t *src_b 
    ;rdx = uint8_t *dst
    ;r9 = pixelesTotales


    movdqa xmm7, [resB]
    movdqa xmm6, [correcionSigno]
    movdqa xmm5 , [resR]
    movdqa xmm10, [resG]


    .recorrerPixeles:

        ; Limpio el registro que voy a usar para guardar el resultado parcial
        pxor xmm3, xmm3

        ; Lleno los registros xmm0/xmm1 con 4 doublewords (4 pixeles)
        movdqu xmm0, [rdi] ; | ARGB | ARGB | ARGB | ARGB |
        movdqu xmm1, [rsi] ; | ARGB | ARGB | ARGB | ARGB |

        ; Pongo la transparencia en 255
        pcmpeqd xmm4, xmm4 ; Todo unos
        pslld xmm4, 24 ; | 1 0 0 0 |
        por xmm3, xmm4

        ; A xmm2 le voy a aplicar el shuffle de caso 1
        ; Quiero conseguir = | 0 0 0 R | 0 0 0 R | 0 0 0 R | 0 0 0 R |
        
        vpshufb xmm2, xmm1, xmm7 ; | 0 0 0 Br | 0 0 0 Br | 0 0 0 Br | 0 0 0 Br |
        
        movdqu xmm4, xmm0 
        
        pslld xmm4, 24 ; | Ab 0 0 0 | Ab 0 0 0 | Ab 0 0 0 | Ab 0 0 0 |
        psrld xmm4, 24 ; | 0 0 0 Ab | 0 0 0 Ab | 0 0 0 Ab | 0 0 0 Ab |

        ; xmm4 = | 0 0 0 Ab | 0 0 0 Ab | 0 0 0 Ab | 0 0 0 Ab |
        ; xmm2 = | 0 0 0 Br | 0 0 0 Br | 0 0 0 Br | 0 0 0 Br |
        ; xmm3 = | 1 0 0 0 | 1 0 0 0 | 1 0 0 0 | 1 0 0 0 |

        paddb xmm4, xmm2 ; | 0 0 0 Ab + Br | 0 0 0 Ab + Br | 0 0 0 Ab + Br | 0 0 0 Ab + Br|
        paddb xmm3, xmm4 ; | 1 0 0 Ab + Br | 1 0 0 Ab + Br | 1 0 0 Ab + Br | 1 0 0 Ab + Br|
        
        ; Ahora voy a conseguir que la componente R de xmm3 sea Bb - Ar

        ; xmm0 = img A
        ; xmm1 = img B
        ; xmm3 = resultadoParcial

        vpshufb xmm2, xmm1, xmm5 ; | 0 Bb 0 0 | 0 Bb 0 0 | 0 Bb 0 0 | 0 Bb 0 0 |

        movdqu xmm4, xmm0 
        pslld xmm4, 8 ; | Ar Ag Ab 0 | Ar Ag Ab 0 | Ar Ag Ab 0 | Ar Ag Ab 0 |
        psrld xmm4, 24 ; | 0 0 0 Ar | 0 0 0 Ar | 0 0 0 Ar | 0 0 0 Ar |
        pslld xmm4, 16 ; | 0 Ar 0 0 | 0 Ar 0 0 | 0 Ar 0 0 | 0 Ar 0 0 |

        psubb xmm2, xmm4 ;| 0 Bb-Ar 0 0 | 0 Bb-Ar 0 0 | 0 Bb-Ar 0 0 | 0 Bb-Ar 0 0 |
        paddb xmm3, xmm2 ; | 1 Bb-Ar 0 Ab + Br | 1 Bb-Ar 0 Ab + Br | 1 Bb-Ar 0 Ab + Br | 1 Bb-Ar 0 Ab + Br|

        ; Me esta quedando conseguir el valor de la componente g del resultado
        
        ; Para ver si  Ag > Bg
        ; La comparacion es con signo, yo uso de 0 a 255 sin signo, es decir se representan 255 numeros
        ; para pasarlo a sin signo el rango seria de -128 a 128, representando los mismos numeros,
        ; tendria que restar a cada byte (componente) 128 o sumarlo

        paddb xmm0, xmm6
        paddb xmm1, xmm6

        ; Ahora que aplique el signfix a ambas imagenes puedo compararlas 
        
        vpcmpgtb xmm4, xmm0, xmm1 ; | ? ? Ag > Bg ? | ? ? Ag > Bg ? | ? ? Ag > Bg ? | ? ? Ag > Bg ? |

        pslld xmm4, 16 ; | Ag > Bg 0 0 0 | Ag > Bg 0 0 0 | Ag > Bg 0 0 0 | Ag > Bg 0 0 0 |
        psrad xmm4, 24 ; | Ag > Bg Ag > Bg Ag > Bg Ag > Bg |

        ; Ahora xmm4 esta o todo en 1 o todo en 0

        ; Restauro los valores de xmm0 y xmm1
        paddb xmm0, xmm6
        paddb xmm1, xmm6

        ; Si es todo 1 la componente ResG -> Ag - Bg
        ; Si es todo 0 Ag + Bg

        pshufb xmm0, xmm10 ; | 0 Ag 0 0 | 0 Ag 0 0 | 0 Ag 0 0 | 0 Ag 0 0|
        pshufb xmm1, xmm10 ; | 0 Bg 0 0 | 0 Bg 0 0 | 0 Bg 0 0 | 0 Bg 0 0|

        movdqu xmm2, xmm0

        psubb xmm0, xmm1 ; | 0 Ag-Bg 0 0 | 0 Ag-Bg 0 0 | 0 Ag-Bg 0 0 | 0 Ag-Bg 0 0|
        pand xmm0, xmm4 ; Solo me queda Ag-Bg si xmm4 es todo unos


        pcmpeqw xmm9, xmm9 
        pxor xmm4 , xmm9 ; Invierto  Ag > Bg, si antes era todo 1 el or dio bien, ahora quiero que esa todo 0 asi me da el por

        pavgb xmm2, xmm1 ; | 0 Promedio 0 0 | 0 Promedio 0 0 | 0 Promedio 0 0 | 0 Promedio 0 0|
        pand xmm2, xmm4


        ; Solo uno de los dos va a tener el valor apropiado y sera distinto de 0, es decir solo una de estas sumas se realiza
        
        paddb xmm3, xmm2 ;| 1 Bb-Ar Promedio Ab + Br | 1 Bb-Ar Promedio Ab + Br | 1 Bb-Ar Promedio Ab + Br | 1 Bb-Ar Promedio Ab + Br|
        paddb xmm3, xmm0 ; | 1 Bb-Ar Ag-Bg Ab + Br | 1 Bb-Ar Ag-Bg Ab + Br | 1 Bb-Ar Ag-Bg Ab + Br | 1 Bb-Ar Ag-Bg Ab + Br|

        ; Guardo el resultado parcial

        movdqu [rdx], xmm3
        
            .siguienteIteracion:
                ; Adelanto los punteros 16 bytes (4 pixeles)
                add rdi, 16
                add rsi, 16
                add rdx, 16
                
                ; Resto los pixeles ya recorridos de los restantes
                sub r9, 4    

                ; Verifico si quedan pixeles
                cmp r9, 0
                jne .recorrerPixeles



    pop rbp
    
    ret