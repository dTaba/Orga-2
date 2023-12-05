section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm
global split_pagos_usuario_asm

extern malloc
extern free
extern strcmp
extern calloc


; Struct listT
%define OFFSET_LIST_T 16
%define OFFSET_LIST_T_FIRST 0
%define OFFSET_LIST_T_LAST 8

; Struct listElem
%define OFFSET_LIST_ELEM 24
%define OFFSET_LIST_ELEM_DATA 0
%define OFFSET_LIST_ELEM_SIGUIENTE_NODO 8
%define OFFSET_LIST_ELEM_ANTERIOR_NODO 16

; Struct pagoT
%define OFFSET_PAGO_T 24
%define OFFSET_MONTO 0
%define OFFSET_APROBADO 1
%define OFFSET_PAGADOR 8
%define OFFSET_COBRADOR 16

; Struct pagoSplitted
%define OFFSET_PAGO_SPLITTED 24
%define OFFSET_CANT_APROBADOS 0
%define OFFSET_CANT_RECHAZADOS 1
%define OFFSET_LISTA_APROBADOS 8
%define OFFSET_LISTA_RECHAZADOS 16



;########### SECCION DE TEXTO (PROGRAMA)

; rdi = list_t* pList
; rsi = char* usuario
contar_pagos_aprobados_asm:
    push rbp
    mov rbp, rsp

    ; Preservo el valor anterior
    ; de los no volatiles

    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    ; Como voy a llamar a strcmp
    ; guardo los parametros en registros
    ; no volatiles

    mov r12, rdi ; list_t* pList
    mov r13, rsi ; char* usuario

    ; Guardo el bool de es ultimo
    ; en r14, me asegura que el
    ; strcmp no me lo cambia
    ; uso r14b
    
    xor r14, r14 ; bool esUltimo

    ; Guardo el contador de pagos
    ; aprobados uso r15b

    xor r15, r15 ; contadorDePagos

    ; Me guardo el ultimo nodo
    ; en rbx para saber cuando terminar

    mov rbx, qword[rdi + OFFSET_LIST_T_LAST] ; listElem_t*
    
    ; Me guardo el primer nodo en
    ; rbp

    mov rbp, qword[rdi + OFFSET_LIST_T_FIRST] ; listElem_t*

    
    ; Limpio r8 y r9 ya que los uso

    xor r8, r8
    xor r9,r9
    
    .cicloAprobados:

        
        ; Me traigo el puntero pagoT a r8
        mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
        
        ; Agarro el byte de aprobado
        mov r9b, byte[r8 + OFFSET_APROBADO]
        
        ; Si es 1 voy al ciclo de aprobado
        cmp r9b, 0
        jne .aprobado

        ; Caso contrario itero otra vez
        jmp .siguienteIteracionAprobado
        
        
        
        .aprobado:

            ; Acomodo los parametros de strcmp

            mov rdi, r13
            
            mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
            
            mov rsi, [r8 + OFFSET_COBRADOR]

            call strcmp
            
            ; Ahora tengo en rax 0 si son iguales

            cmp rax, 0
            je .encontrado


            ;Si no lo encuentro voy a la siguiente iteracion

            jmp .siguienteIteracionAprobado
        
        .encontrado:

            ; Incremento el contador
            inc r15
            jmp .siguienteIteracionAprobado

        
        .siguienteIteracionAprobado:

            ; Reviso si es la ultima posicion

            cmp rbp, rbx
            je .fin

            ; Caso contrario adelanto el puntero y sigo

            mov rbp, [rbp + OFFSET_LIST_ELEM_SIGUIENTE_NODO]
            jmp .cicloAprobados
    
    .fin:

    xor rax, rax

    mov rax, r15


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

    ; Preservo el valor anterior
    ; de los no volatiles

    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    ; Como voy a llamar a strcmp
    ; guardo los parametros en registros
    ; no volatiles

    mov r12, rdi ; list_t* pList
    mov r13, rsi ; char* usuario

    ; Guardo el bool de es ultimo
    ; en r14, me asegura que el
    ; strcmp no me lo cambia
    ; uso r14b
    
    xor r14, r14 ; bool esUltimo

    ; Guardo el contador de pagos
    ; aprobados uso r15b

    xor r15, r15 ; contadorDePagos

    ; Me guardo el ultimo nodo
    ; en rbx para saber cuando terminar

    mov rbx, qword[rdi + OFFSET_LIST_T_LAST] ; listElem_t*
    
    ; Me guardo el primer nodo en
    ; rbp

    mov rbp, qword[rdi + OFFSET_LIST_T_FIRST] ; listElem_t*

    
    ; Limpio r8 y r9 ya que los uso

    xor r8, r8
    xor r9,r9
    
    .cicloRechazados:

        
        ; Me traigo el puntero pagoT a r8
        mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
        
        ; Agarro el byte de aprobado
        mov r9b, byte[r8 + OFFSET_APROBADO]
        
        ; Si es 1 voy al ciclo rechazado
        cmp r9b, 1
        jne .rechazado

        ; Caso contrario itero otra vez
        jmp .siguienteIteracionRechazado
        
        
        
        .rechazado:

            ; Acomodo los parametros de strcmp

            mov rdi, r13
            
            mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
            
            mov rsi, [r8 + OFFSET_COBRADOR]

            call strcmp
            
            ; Ahora tengo en rax 0 si son iguales

            cmp rax, 0
            je .encontrado2


            ;Si no lo encuentro voy a la siguiente iteracion

            jmp .siguienteIteracionRechazado
        
        .encontrado2:

            ; Incremento el contador
            inc r15
            jmp .siguienteIteracionRechazado

        
        .siguienteIteracionRechazado:

            ; Reviso si es la ultima posicion

            cmp rbp, rbx
            je .fin

            ; Caso contrario adelanto el puntero y sigo

            mov rbp, [rbp + OFFSET_LIST_ELEM_SIGUIENTE_NODO]
            jmp .cicloRechazados
    
    .fin:

    xor rax, rax

    mov rax, r15


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret

; rdi = list_t* pList
; rsi = char* usuario
split_pagos_usuario_asm:
    push rbp
    mov rbp, rsp

    ; Pusheo los no volatiles
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8


    mov r12, rdi ; list_t* pList
    mov r13, rsi ; char* usuario


    call contar_pagos_aprobados_asm
    
    xor r14, r14
    mov r14, rax ; Cantidad pagos aprobados
    
    mov rdi, r12
    mov rsi, r13
    
    call contar_pagos_rechazados_asm

    xor r15, r15
    mov r15, rax ; Cantidad pagos rechazados

    ; Pido memoria pagoSplited
    xor rdi, rdi
    add rdi, OFFSET_PAGO_SPLITTED

    call malloc

    mov rbx, rax ; Puntero a pagoSplitted

    ; Pido memoria puntero puntero aprobados
    
    xor rdi, rdi
    mov rdi, 8

    call malloc

    mov qword[rbx + OFFSET_LISTA_APROBADOS], rax

    ; Pido memoria a puntero rechazados

    xor rdi, rdi
    mov rdi, 8

    call malloc

    mov qword[rbx + OFFSET_LISTA_RECHAZADOS], rax

    ;Pido memoria para la cantidad de pagos aprobados

    mov rdi, r14
    mov rsi, OFFSET_PAGO_T

    call calloc
    
    mov r8, qword[rbx + OFFSET_LISTA_APROBADOS]
    mov [r8], rax

    ;Pido memoria para la cantidad de pagos rechazados


    mov rdi, r15
    mov rsi, OFFSET_PAGO_T

    call calloc
    
    mov r8, qword[rbx + OFFSET_LISTA_RECHAZADOS]
    mov [r8], rax

    ; Asigno la cantidad de aprobados y rechazados

    mov byte[rbx + OFFSET_CANT_APROBADOS], r14b
    mov byte[rbx + OFFSET_CANT_RECHAZADOS], r15b

    ; Me guardo el primer nodo en
    ; rbp

    mov rbp, qword[r12 + OFFSET_LIST_T_FIRST] ; listElem_t*

    ; Me guardo el ultimo nodo
    ; en r12 para saber cuando terminar

    mov r15, qword[r12 + OFFSET_LIST_T_LAST] ; listElem_t*
    
    ; Limpio r8 y r9 ya que los uso

    xor r8, r8
    xor r9,r9

    ; Puntero lista aprobados y rechazados

    mov r14, [rbx + OFFSET_LISTA_APROBADOS]
    mov r12, [rbx + OFFSET_LISTA_RECHAZADOS]

    ; rbx = pagoSplitted
    ; r13 = usuario
    ; r14 = puntero a Aprobados
    ; r12 = puntero a Rechazados 
    ; r15 = ultimo nodo
    ; rbp = primer nodo
    
    .cicloSplit:

        
        ; Me traigo el puntero pagoT a r8
        mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
        
        ; Agarro el byte de aprobado
        mov r9b, byte[r8 + OFFSET_APROBADO]
        
        ; o salto a uno o salto a otro
        cmp r9b, 1
        jne .rechazadoSplit
        jmp .aceptadoSplit
        
        .aceptadoSplit:

            ; Acomodo los parametros de strcmp

            mov rdi, r13
            
            mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
            
            mov rsi, [r8 + OFFSET_COBRADOR]

            call strcmp
            
            ; Ahora tengo en rax 0 si son iguales

            cmp rax, 0
            je .encontradoAceptado


            ;Si no lo encuentro voy a la siguiente iteracion

            jmp .siguienteIteracionSplit
        
        .rechazadoSplit:

            ; Acomodo los parametros de strcmp

            mov rdi, r13
            
            mov r8, [rbp + OFFSET_LIST_ELEM_DATA]
            
            mov rsi, [r8 + OFFSET_COBRADOR]

            call strcmp
            
            ; Ahora tengo en rax 0 si son iguales

            cmp rax, 0
            je .encontradoRechazado


            ;Si no lo encuentro voy a la siguiente iteracion

            jmp .siguienteIteracionSplit


        .encontradoRechazado:
            ; rbx = pagoSplitted
            ; r13 = usuario
            ; r14 = puntero a Aprobados
            ; r12 = puntero a Rechazados 
            ; r15 = ultimo nodo
            ; rbp = primer nodo

            ; Traigo el puntero pago t
            mov r9 , [rbp + OFFSET_LIST_ELEM_DATA]

            ; Traigo el puntero a la lista
            mov r8, [rbx + OFFSET_LISTA_RECHAZADOS]

            ; Le asigo el puntero pago t al puntero a la lista
            mov [r8], r9

            ; Adelanto el puntero a la lista
            add r12, OFFSET_PAGO_T

            jmp .siguienteIteracionSplit
        
        .encontradoAceptado:
            ; rbx = pagoSplitted
            ; r13 = usuario
            ; r14 = puntero a Aprobados
            ; r12 = puntero a Rechazados 
            ; r15 = ultimo nodo
            ; rbp = primer nodo

            ; Traigo el puntero pago t
            mov r9 , [rbp + OFFSET_LIST_ELEM_DATA]

            ; Traigo el puntero a la lista
            mov r8, [rbx + OFFSET_LISTA_APROBADOS]

            ; Le asigo el puntero pago t al puntero a la lista
            mov [r8], r9

            ; Adelanto el puntero a la lista
            add r14, OFFSET_PAGO_T

            jmp .siguienteIteracionSplit


        .siguienteIteracionSplit:

            ; Reviso si es la ultima posicion

            cmp rbp, r15
            je .fin

            ; Caso contrario adelanto el puntero y sigo

            mov rbp, [rbp + OFFSET_LIST_ELEM_SIGUIENTE_NODO]
            jmp .cicloSplit
    
    .fin:


    mov rax, rbx




    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret

