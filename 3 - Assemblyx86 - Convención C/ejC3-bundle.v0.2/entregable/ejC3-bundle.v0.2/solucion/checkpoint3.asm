

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar:
NODO_LENGTH	EQU	32
LONGITUD_OFFSET	EQU	24

PACKED_NODO_LENGTH	EQU	21
PACKED_LONGITUD_OFFSET	EQU	17

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos:
	push rbp
	mov rbp, rsp

	xor rax, rax ;rax = 0

	.startwhile3: ;while actual->next != 0 then
		mov rdi, [rdi] ;nos paramos en el proximo nodo
		cmp rdi, 0x0
		jz .endwhile3
		add eax, [rdi + LONGITUD_OFFSET] ;agregamos la length
		jmp .startwhile3
	.endwhile3:

	pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	push rbp
	mov rbp, rsp

	xor rax, rax ;rax = 0

	.startwhilepaqueado: ;while r8 != 0 then
		mov rdi, [rdi] ;nos paramos en el proximo nodo
		cmp rdi, 0x0
		jz .endwhilepaqueado
		add eax, [rdi + PACKED_LONGITUD_OFFSET] ;agregamos la length
		jmp .startwhilepaqueado
	.endwhilepaqueado:

	pop rbp
	ret
