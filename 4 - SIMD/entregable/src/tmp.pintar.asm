push rbp
	mov rbp, rsp
	 
	sub rcx, 4; le restamos 4 a la altura para los casos particulares
	shl rdx, 2 ; Como agarramos de a 4 pixeles lo dividimos por 4 el ancho

	pcmpeqq xmm0, xmm0 ;creamos la mascara de 4 pixels blancos (todo en 1)
	pcmpeqq xmm1, xmm1 ;creamos una mascara de todos los bits en uno

	psrld xmm1, 24 ;shifteamos a la derecha 24 bits por doubleword para tener 4 pixels negros

	; Pintar primeras dos filas de negro
	mov r10, rdx
	.recorrerWidthNegro1:
	movdqu [rsi], xmm1

	add rsi, 4 * PX_OFFSET
	sub r10, 1
	cmp r10, 0
	jnz .recorrerWidthNegro1

	mov r10, rdx
	.recorrerWidthNegro2:
	movdqu [rsi], xmm1

	add rsi, 4 * PX_OFFSET
	sub r10, 1
	cmp r10, 0
	jnz .recorrerWidthNegro2

	.recorrerHeight:
	mov r10, rdx ; Resetear width para loopear
	sub r10, 2
	movdqu [rsi], xmm1
	; Pintar los primeros 4 pixeles de negro y blanco
	.recorrerWidth:

	movdqu [rsi], xmm0


	add rsi, 4 * PX_OFFSET
	sub r10, 1
	cmp r10, 0
	jnz .recorrerWidth

	; Pintar los ultimos 4 pixeles de blanco y negro
	movdqu [rsi], xmm1
	loop .recorrerHeight
	; Pintar las ultimas 2 filas de negro
	mov r10, rdx
	.recorrerWidthNegro3:
	movdqu [rsi], xmm1

	add rsi, 4 * PX_OFFSET
	sub r10, 1
	cmp r10, 0
	jnz .recorrerWidthNegro3

	mov r10, rdx
	.recorrerWidthNegro4:
	movdqu [rsi], xmm1

	add rsi, 4 * PX_OFFSET
	sub r10, 1
	cmp r10, 0
	jnz .recorrerWidthNegro4

	pop rbp
	ret