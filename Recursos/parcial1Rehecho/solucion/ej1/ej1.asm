section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm

global split_pagos_usuario_asm

extern calloc
extern malloc
extern free
extern strcmp

; pago_t
%define OFFSET_PAGO 24
%define OFFSET_PAGO_MONTO 0
%define OFFSET_PAGO_APROBADO 1
%define OFFSET_PAGO_PAGADOR 8
%define OFFSET_PAGO_COBRADOR 16

; pagoSplitted
%define OFFSET_PAGO_SPLITTED 24
%define OFFSET_PAGO_SPLITTED_CANT_APROBADOS 0
%define OFFSET_PAGO_SPLITTED_CANT_RECHAZADOS  1
%define OFFSET_PAGO_SPLITTED_APROBADOS  8
%define OFFSET_PAGO_SPLITTED_RECHAZADOS 16

; listElem
%define OFFSET_LIST_ELEM 24
%define OFFSET_LIST_ELEM_DATA 0
%define OFFSET_LIST_ELEM_NEXT 8
%define OFFSET_LIST_ELEM_PREV 16

; list
%define OFFSET_LIST 8
%define OFFSET_LIST_FIRST 0
%define OFFSET_LIST_LAST 8



;########### SECCION DE TEXTO (PROGRAMA)

; uint8_t contar_pagos_aprobados_asm(list_t* pList, char* usuario);
contar_pagos_aprobados_asm:
    
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    
    ; Como voy a llamar a funciones de c me guardo las variables en los
    ; no volatiles

    xor rbx, rbx
    
    mov r12, [rdi + OFFSET_LIST_FIRST]
    mov r13, [rdi + OFFSET_LIST_LAST]
    mov r14, rsi

    ; rbx = cantAprobados
    
    ; r12 = nodoActual -> listElem
    ; r13 = ultimoNodo -> listElem

    ; r14 = char* usuario

    ; rbp y r15 libres

    .recorrerEnlazada:

        mov r8, [r12 + OFFSET_LIST_ELEM_DATA] ; pago_t *      
        mov rdi, [r8 + OFFSET_PAGO_COBRADOR] ; string cobrador

        mov rsi, r14 ; string parametro

        call strcmp

        ; Verifico si es el cobrador o no

        cmp rax, 0
        jne .adelantarNodo

        ; Es el cobrador, resta ver que este aprobado
    

        xor rdi, rdi

        mov r8, [r12 + OFFSET_LIST_ELEM_DATA] ; pago_t 
        mov dil, [r8 + OFFSET_PAGO_APROBADO] ; aprobado 1 o 0
        
        cmp dil, 0
        je .adelantarNodo

        ; Paso las verificaciones, lo sumo
        inc rbx

        .adelantarNodo:
            
            cmp r13, r12 
            je .devolverResultado
            
            mov r12, [r12 + OFFSET_LIST_ELEM_NEXT]
            jmp .recorrerEnlazada

        
    .devolverResultado:
        xor rax, rax
        mov rax, rbx


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp

    ret

; uint8_t contar_pagos_rechazados_asm(list_t* pList, char* usuario);
contar_pagos_rechazados_asm:
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8
    
    ; Como voy a llamar a funciones de c me guardo las variables en los
    ; no volatiles

    xor rbx, rbx
    
    mov r12, [rdi + OFFSET_LIST_FIRST]
    mov r13, [rdi + OFFSET_LIST_LAST]
    mov r14, rsi

    ; rbx = cantAprobados
    
    ; r12 = nodoActual -> listElem
    ; r13 = ultimoNodo -> listElem

    ; r14 = char* usuario

    ; rbp y r15 libres

    .recorrerEnlazada:

        mov r8, [r12 + OFFSET_LIST_ELEM_DATA] ; pago_t *      
        mov rdi, [r8 + OFFSET_PAGO_COBRADOR] ; string cobrador

        mov rsi, r14 ; string parametro

        call strcmp

        ; Verifico si es el cobrador o no

        cmp rax, 0
        jne .adelantarNodo

        ; Es el cobrador, resta ver que este aprobado
    

        xor rdi, rdi

        mov r8, [r12 + OFFSET_LIST_ELEM_DATA] ; pago_t 
        mov dil, [r8 + OFFSET_PAGO_APROBADO] ; aprobado 1 o 0
        
        cmp dil, 1
        je .adelantarNodo

        ; Paso las verificaciones, lo sumo
        inc rbx

        .adelantarNodo:
            
            cmp r13, r12 
            je .devolverResultado
            
            mov r12, [r12 + OFFSET_LIST_ELEM_NEXT]
            jmp .recorrerEnlazada

        
    .devolverResultado:
        xor rax, rax
        mov rax, rbx


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp

    ret

; pagoSplitted_t* split_pagos_usuario_asm(list_t* pList, char* usuario);
split_pagos_usuario_asm:
    ; rdi = list_t* pList
    ; rsi = char* usuario

    push rbp
    mov rbp, rsp

    ; Preservo el valor de los no volatiles

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; Guardo los parametros en registros no volatiles

    mov rbp, rdi
    mov rbx, rsi

    call contar_pagos_aprobados_asm
    
    mov r12, rax

    ; Acomodo los parametros por si fueron modificados y llamo a pagos rechazados

    mov rdi, rbp
    mov rsi, rbx

    call contar_pagos_rechazados_asm

    mov r13, rax

    ; Pido memoria para el pagoSplitted

    xor rdi, rdi
    mov rdi, OFFSET_PAGO_SPLITTED
    
    call malloc

    mov r14, rax

    ; r12 = cantAprobados
    ; r13 = cantRechazados
    ; r14 = pagoSplitted*
    ; rbp = list_t* pList
    ; rbx = char* usuario 

    mov byte [r14 + OFFSET_PAGO_SPLITTED_CANT_APROBADOS], r12b
    mov byte [r14 + OFFSET_PAGO_SPLITTED_CANT_RECHAZADOS], r13b


    ; Asigno el espacio de memoria para pagos aprobados
    
    mov rdi, r12
    mov rsi, 8

    call calloc
  
    mov [r14 + OFFSET_PAGO_SPLITTED_APROBADOS], rax

    ;Asigno el espacio de memoria para pagos rechazados
    
    mov rdi, r13
    mov rsi, 8

    call calloc
    
    mov [r14 + OFFSET_PAGO_SPLITTED_RECHAZADOS], rax

    ; Me queda recorrer toda la lista enlazada e ir agregando los pagos

    mov r12, [rbp + OFFSET_LIST_FIRST]
    mov r13, [rbp + OFFSET_LIST_LAST]
    
    xor rbp, rbp
    xor r15, r15
    
    ; r12 = nodoActual
    ; r13 = ultimoNodo
    ; r14 = pagoSplitted*
    ; r15 = indiceAprobados
    ; rbp = indiceRechazados
    ; rbx = char* usuario 

    .enlazada:
        ; Verifico que sea cobrador

        mov rdi, rbx
        
        mov r8, [r12 + OFFSET_LIST_ELEM_DATA]
        mov rsi, [r8 + OFFSET_PAGO_COBRADOR]

        call strcmp

        cmp rax, 0
        jne .siguienteNodo

        ; Verifico si esta aprobado o rechazado
        
        mov r8, [r12 + OFFSET_LIST_ELEM_DATA]
        xor r9, r9
        mov r9b, byte[r8 + OFFSET_PAGO_APROBADO]

        cmp r9b, 0
        je .rechazado
        jmp .aprobado

        .rechazado:

            ; Obtengo el puntero al pago
            mov r9, [r12 + OFFSET_LIST_ELEM_DATA]
            
            ; Obtengo el puntero a la lista de pagos aprobados
            mov r8, [r14 + OFFSET_PAGO_SPLITTED_RECHAZADOS]

            ; Guardo el puntero en la lista
            mov [r8 + rbp], r9

            ; Adelanto la lista 8 bytes
            add rbp, 8

            jmp .siguienteNodo


        .aprobado:
            ; Obtengo el puntero al pago
            mov r9, [r12 + OFFSET_LIST_ELEM_DATA]
            
            ; Obtengo el puntero a la lista de pagos aprobados
            mov r8, [r14 + OFFSET_PAGO_SPLITTED_APROBADOS]
            
            ; Guardo el puntero en la lista
            mov [r8 + r15], r9

            ; Adelanto la lista 8 bytes
            add r15, 8
            
            jmp .siguienteNodo

        .siguienteNodo:
            ; Me fijo si estoy en el ultimo nodo
            
            cmp r12, r13
            je .fin

            ; Caso contrario

            mov r8, [r12 + OFFSET_LIST_ELEM_NEXT]
            mov r12, r8

            jmp .enlazada

    .fin:

    mov rax, r14

    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    pop rbp
    ret