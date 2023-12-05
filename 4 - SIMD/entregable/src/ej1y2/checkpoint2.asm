TERNAS_LENGTH EQU 64	; 8 * [sizeof(A) + sizeof(B) + sizeof(C)] = 8 * [2 + 2 + 4] = 64
B_OFFSET EQU 16			; 8 * sizeof(A) = 16
CL_OFFSET EQU 32		; 8 * [sizeof(A) + sizeof(B)] = 32
CH_OFFSET EQU 48		; 8 * [sizeof(A) + sizeof(B)] + 4 * sizeof(C) = 48


section .text

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)
; rdi: void* array, rci: uint32_t n
; El arreglo es [ |A00, ..., A07,B00, ..., B07, C00, ..., C07|, ..., |Aji, ..., Bji, ..., Cji|, ..., |A(n-1)i, ..., B(n-1)i, ..., C(n-1)i|]
; Donde A y B son enteros sin signo de 16 bits (uint16_t) y C son enteros sin signo de 32 bits (uint32_t)
; Checkear que Cji = (Aji + Bji) * 8 \forall ji
; Devolver 1 (True) o 0 (False)
checksum_asm:
	push rbp
	mov rbp, rsp

	xor rax, rax	; Por default devuelvo 0

	mov rcx, rsi	; Uso rcx para loopear

	.iterar_arreglo:
		; Cargo las ternas en registros
		movdqu xmm0, [rdi]				;	|  Aj0	|			   ...				|  Aj7	|
		movdqu xmm1, [rdi + B_OFFSET]	;	|  Bj0	|			   ...				|  Bj7	|
		movdqu xmm2, [rdi + CL_OFFSET]	;	| 	   Cj0		|      ...		|	   Cj3		|
		movdqu xmm3, [rdi + CH_OFFSET]	;	| 	   Cj4		|      ...		|	   Cj7		|

		; Sumo A+B
		paddw xmm0, xmm1				;	|Aj0+Bj0|			   ...				|Aj7+Bj7|
		pmovzxwd xmm1, xmm0				;	| 	 Aj0+Bj0	|      ...		| 	 Aj3+Bj3	|
		psrldq xmm0, 8		; xmm0 >> 64
		pmovzxwd xmm0, xmm0				;	| 	 Aj4+Bj4	|      ...		| 	 Aj7+Bj7	|

		; Multiplico la suma por 8 (<< 3)
		pslld xmm0, 3
		pslld xmm1, 3

		; Comparo los resultados
		pcmpeqd xmm1, xmm2
		pmovmskb r8d, xmm1
		cmp r8d, 0xFFFF			; 0000000000000000000000000000000000000000000000001111111111111111
		jnz .return_checksum
		
		pcmpeqd xmm0, xmm3
		pmovmskb r8d, xmm0
		cmp r8d, 0xFFFF
		jnz .return_checksum

		add rdi, TERNAS_LENGTH
	loop .iterar_arreglo

	; No se encontró terna que no cumpla Cji = (Aji + Bji) * 8 => Devuelvo 1
	mov eax, 1

	.return_checksum:
	pop rbp
	ret

