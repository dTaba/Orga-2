PX_OFFSET EQU 4

section .rodata
todo_negro: db 0, 0, 0, 0xFF, 0, 0, 0, 0xFF, 0, 0, 0, 0xFF, 0, 0, 0, 0xFF
todo_blanco: db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF


section .text
global Pintar_asm

;void Pintar_asm(unsigned char *src,
;              unsigned char *dst,
;              int width,
;              int height,
;              int src_row_size,
;              int dst_row_size);


; rdi = *src matrix de pixeles 
; rsi = *dst imagen destino
; rdx = width
; rcx = height
; r8 = src_row_size
; r9 = dst_row_size

Pintar_asm:
	push rbp
	mov rbp, rsp
	push r15

	shr rdx, 2	; Voy a procesar de a 4 pixeles, por lo que divido la cantidad de columnas por 4

	movdqu xmm0, [todo_blanco]	; xmm0 = 4 pixeles blancos
	movdqu xmm1, [todo_negro]	; xmm0 = 4 pixeles negros

	; Guardo las cosas auxiliares para poder usar loop
	mov r15, rcx
	mov rcx, rdx
	shl rcx, 1	; RCX es la cantidad de packetes

	; Recorro las primeras 2 filas pintandolas de negro
	.primeras_filas:
		movdqu [rsi], xmm1
		add rsi, 4 * PX_OFFSET
	loop .primeras_filas


	sub rdx, 1	; Una columna la resuelvo ad-hoc, por lo que no entra en el loop general

	mov rcx, r15
	sub rcx, 4
	; Pinto los primeros 4 pixeles de negro, pero despues sobreescribo los segundos dos
	movdqu [rsi], xmm1
	add rsi, 2 * PX_OFFSET

	.loop_fila:
		mov r15, rcx	; Guardo la cantidad de filas que faltan procesar en un registro auxiliar
		mov rcx, rdx	; Reseteo la cantidad de columnas que faltan procesar

		.loop_columna:
			movdqu [rsi], xmm0		; Pinto los cuatro pixeles de blanco
			add rsi, 4 * PX_OFFSET	; Avanzo 4 pixeles
		loop .loop_columna

		movdqu [rsi], xmm1			; Pinto los cuatro pixeles de negro
		add rsi, 4 * PX_OFFSET		; Avanzo 4 pixeles
		
		mov rcx, r15	; Recuerdo la cantidad de filas que faltan procesar para loopear correctamente.
	loop .loop_fila

	; El loop general escribió los primeros 2 pixeles de las ultimas 2 filas.
	; Vuelvo el puntero 2 pixeles para atrás para sobreescribirlos.
	sub rsi, 2 * PX_OFFSET
	
	mov r15, rcx
	mov rcx, rdx
	
	; Reacomodo la cantidad de columnas
	add rcx, 1
	; Voy a pintar dos filas por lo que suplico rcx
	shl rcx, 1
	.ultimas_filas:
		movdqu [rsi], xmm1
		add rsi, 4 * PX_OFFSET
	loop .ultimas_filas

	pop r15
	pop rbp
	ret
	


