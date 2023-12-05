; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start


; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
extern GDT_DESC
extern screen_draw_layout
extern screen_draw_smiley
extern screen_draw_cat
extern idt_init
extern IDT_DESC
extern pic_reset
extern pic_enable
extern mmu_init_kernel_dir
extern copy_page
extern mmu_init_task_dir

; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
%define CS_RING_0_SEL 0x0008
%define DS_RING_0_SEL 0x0018

BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; COMPLETAR - Deshabilitar interrupciones
    CLI

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO REAL
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)
    print_text_rm start_rm_msg, start_rm_len, 0x0F, 0, 0

    ; COMPLETAR - Habilitar A20
    ; (revisar las funciones definidas en a20.asm)
    call A20_enable

    ; COMPLETAR - Cargar la GDT
    LGDT [GDT_DESC]

    ; COMPLETAR - Setear el bit PE del registro CR0
    MOV EAX, CR0
    OR EAX, 1
    MOV CR0, EAX

    ; COMPLETAR - Saltar a modo protegido (far jump)
    ; (recuerden que un far jmp se especifica como jmp CS_selector:address)
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo
    jmp CS_RING_0_SEL:modo_protegido

BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
    
    mov ax, DS_RING_0_SEL

    mov ds, ax ; Data Segment (used for MOV)  
    mov es, ax ; Destination Segment (used for MOVS, etc.)  mov [es:0xfff5ad], 0 

    ; Se utilizan para acceder a segmentos de datos adicionales en el espacio de direcciones lineales
    mov gs, ax
    mov fs, ax 
    mov ss, ax ; Stack Segment (used for SP) push rbx  (SS:ESP) 

    ; COMPLETAR - Establecer el tope y la base de la pila

    mov esp, 0x25000    ; Establecer el tope de la pila en 0x25000 
    mov ebp, esp        ; Establecer la base de la pila en la misma dirección que el tope de la pila

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO
    print_text_pm start_pm_msg, start_pm_len, 0x0F, 10, 10

    ; COMPLETAR - Inicializar pantalla
    call screen_draw_layout
    call screen_draw_smiley
    call screen_draw_cat

    ; Activamos paginacion.
    call mmu_init_kernel_dir
    mov cr3, eax

    mov eax, cr0
    or eax, 0x80000000 ; 0x80000000 bit de paginación 
    mov cr0, eax ; le meto la nueva config con el bit de paginacion activado
    
    ; Completamos el IDT
    call idt_init
    lidt [IDT_DESC]


    ; Activamos las interrupciones.
    call pic_reset
    call pic_enable
    sti


    push 0xC00000
    push 0xD00000
    call copy_page
    pop edi
    pop edi

    push 0x18000            ; Codigo de tarea
    call mmu_init_task_dir  ; Inicializo las estructuras de paginacion
    pop edi

    mov esi, cr3
    mov cr3, eax            ; Ejecuto como si fuera una tarea

    mov [0x7000000], edi    ; Primera escritura en on-demand
    mov [0x7000020], edi    ; Segunda escritura en on-demand
    
    mov cr3, esi            ; Vuelvo a la normalidad

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
