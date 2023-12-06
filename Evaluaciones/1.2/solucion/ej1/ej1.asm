; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

section .data

OFFSET_LIST EQU 16
OFFSET_LIST_T_FIRST EQU 0
OFFSET_LIST_T_LAST EQU 8
OFFSET_NODE EQU 32
OFFSET_NODE_NEXT EQU 0
OFFSET_NODE_PREVIOUS EQU 8
OFFSET_NODE_TYPE EQU 16
OFFSET_NODE_HASH EQU 24

section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat




string_proc_list_create_asm:
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

    ; Pido memoria para el struct de

    xor rdi, rdi
    mov rdi, OFFSET_LIST
    call malloc


    ; Tengo en rax el puntero a la estructura, le pongo el primero y el ultimo en 0

    xor rdx, rdx

    mov [rax + OFFSET_LIST_T_FIRST], rdx
    mov [rax + OFFSET_LIST_T_LAST], rdx


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret


string_proc_node_create_asm:
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

    ; Guardo lo pasado por parametro en no volatiles ya que voy a llamar a malloc

    mov rbx, rdi ; Type
    mov rbp, rsi ; Hash

    ; Pido memoria para el struct de nodo

    xor rdi, rdi
    mov rdi, OFFSET_NODE

    call malloc

    ; Le asigno los valores que necesito

    mov [rax + OFFSET_NODE_TYPE], rbx
    mov [rax + OFFSET_NODE_HASH], rbp 


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret

string_proc_list_add_node_asm:
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

    ; Guardo lo pasado por parametro en no volatiles ya que voy a llamar createNode

    mov rbx, rdi ; Puntero a la lista
    mov rbp, rsi ; Type
    mov r12, rdx ; Hash


    ; Paso los parametros

    mov rdi, rbp
    mov rsi, rdx

    call string_proc_node_create_asm

    ; Tengo en rax el nodo nuevo, me falta asignarle next y previous

    xor r8, r8
    cmp [rbx + OFFSET_LIST_T_FIRST], r8
    je .noHayPrimerNodo

    ; Caso contrario, si hay primer nodo
    
    mov [rax + OFFSET_NODE_NEXT], r8 ; Le asigno el siguiente a el nuevo nodo como nulo

    mov r9, [rbx + OFFSET_LIST_T_LAST] ; Me traigo el ultimo nodo actual a r9

    mov [rax + OFFSET_NODE_PREVIOUS], r9 ; Le asigno al nodo nuevo el ultimo nodo anterior como previous

    mov [r9 + OFFSET_NODE_NEXT], rax ; Le asigno al ultimo nodo viejo el actual como siguiente

    mov [rbx + OFFSET_LIST_T_LAST], rax ; Actualizo la lista

    jmp .fin


        .noHayPrimerNodo:
            ; Le asigno nulo a siguienteNodo y a previoNodo
            mov [rax + OFFSET_NODE_PREVIOUS], r8
            mov [rax + OFFSET_NODE_NEXT], r8

            ; Lo establezco como First y last
            mov [rbx + OFFSET_LIST_T_FIRST], rax
            mov [rbx + OFFSET_LIST_T_LAST], rax
            
            jmp .fin

    .fin:


    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret
    

string_proc_list_concat_asm:
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


    ; Guardo los parametros que me pasan 
    ; a no volatiles ya que voy a llamar a str_concat

    mov rbx, rdi ; Puntero a la lista
    mov rbp, rsi ; Type
    mov r12, rdx ; Hash
    

    ; Traigo el primer nodo para empezar a recorrer la lista

    mov r13, [rbx + OFFSET_LIST_T_FIRST]

    ; rbx = Puntero a la lista
    ; rbp = Type
    ; r12 = Hash
    ; r13 = puntero nodoActual
    
    mov r14, r12
    
    ; r14 = resultadoParcialConcat
    


    .recorrerEnlazada:
        cmp [r13 + OFFSET_NODE_TYPE], rbp
        jne .siguienteIteracion

        ; Si tiene el mismo tipo



        mov rdi, r14
        mov rsi, [r13 + OFFSET_NODE_HASH]
        
        call str_concat

        ; Obtengo en rax el espacio de memoria con la concatenacion

        mov r14, rax



        .siguienteIteracion:
            ; Veo si estoy en el ultimo nodo
            xor r9, r9
            cmp [r13 + OFFSET_NODE_NEXT], r9
            je .fin

            ; Caso contrario

            mov r13, [r13 + OFFSET_NODE_NEXT]
            jmp .recorrerEnlazada

    
    .fin:
    
    mov rax, r14
    
    
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12

    pop rbp
    ret