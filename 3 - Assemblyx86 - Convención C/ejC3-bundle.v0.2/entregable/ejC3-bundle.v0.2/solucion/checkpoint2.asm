extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
; x1 - x2 + x3 - x4
alternate_sum_4:
	;prologo
	push rbp
	mov rbp, rsp

	; COMPLETAR

	sub rdi, rsi
	add rdi, rdx
	sub rdi, rcx
	mov rax, rdi
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8

	;epilogo
	pop rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
; x1 - x2 + x3 - x4
alternate_sum_4_using_c:
	;prologo
	push rbp ; alineado a 16
	mov rbp,rsp

	; COMPLETAR



	call restar_c ; lo guarda en rax

	mov rdi, rax
	mov rsi, rdx

	call sumar_c

	mov rdi, rax
	mov rsi, rcx

	call restar_c



	;epilogo
	pop rbp
	ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
; x1 - x2 + x3 - x4
alternate_sum_4_simplified:
	sub rdi, rsi
	add rdi, rdx
	sub rdi, rcx
	mov rax, rdi
	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
; x1 - x2 + x3 - x4 + x5 - x6 + x7 - x8
alternate_sum_8:
	;prologo
	push rbp
	mov rbp, rsp

	; COMPLETAR

	sub edi, esi
	add edi, edx
	sub edi, ecx
	add edi, r8d
	sub edi, r9d

    mov esi, dword [rbp + 0x10]
	add edi, esi
    mov esi, dword [rbp + 0x18]
	sub edi, esi

	mov eax, edi
	
	;epilogo
	pop rbp
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
;
product_2_f:
	cvtsi2ss xmm1, esi ; Convierto uint32 a float

	mulss xmm0, xmm1 ; Multiplico flotantes de simple precision

	cvttss2si esi, xmm0 ; Convierto con truncado el resultado a uint32

    mov dword [rdi], esi

	ret


;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r9], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[stack1], f6[xmm5], x7[stack2], f7[xmm6], x8[stack3], f8[xmm7],
;	, x9[stack4], f9[stack5]

; Stack : [x6, x7, x8, x9, f9]

product_9_f:
    ;prologo
    push rbp
    mov rbp, rsp

    ;convertimos los flotantes de cada registro xmm en doubles
    cvtss2sd xmm0, xmm0
    cvtss2sd xmm1, xmm1
    cvtss2sd xmm2, xmm2
    cvtss2sd xmm3, xmm3
    cvtss2sd xmm4, xmm4
    cvtss2sd xmm5, xmm5
    cvtss2sd xmm6, xmm6
    cvtss2sd xmm7, xmm7

    ;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...

    mulsd xmm0, xmm1
    mulsd xmm0, xmm2
    mulsd xmm0, xmm3
    mulsd xmm0, xmm4
    mulsd xmm0, xmm5
    mulsd xmm0, xmm6
    mulsd xmm0, xmm7

    ;obtengo el float faltante del stack
    movss xmm1, [rbp + 0x30]    ; f9
    cvtss2sd xmm1, xmm1         ; f9
    mulsd xmm0, xmm1            ; xmm0 <- xmm0 * f9

    ; convertimos los enteros en doubles y los multiplicamos por xmm0.
    cvtsi2sd xmm1, esi
    cvtsi2sd xmm2, edx
    cvtsi2sd xmm3, ecx
    cvtsi2sd xmm4, r8d
    cvtsi2sd xmm5, r9d

    mulsd xmm0, xmm1
    mulsd xmm0, xmm2
    mulsd xmm0, xmm3
    mulsd xmm0, xmm4
    mulsd xmm0, xmm5

    ;obtengo los faltantes del Stack : [x6, x7, x8, x9, f9]
    mov dword esi, [rbp + 0x10] ; x6
    mov dword edx, [rbp + 0x18] ; x7
    mov dword ecx, [rbp + 0x20] ; x8
    mov dword r8d, [rbp + 0x28] ; x9

    ;convierto todo a double
    cvtsi2sd xmm1, esi  ; x6
    cvtsi2sd xmm2, edx  ; x7
    cvtsi2sd xmm3, ecx  ; x8
    cvtsi2sd xmm4, r8d  ; x9

    ;multiplico todo
    mulsd xmm0, xmm1
    mulsd xmm0, xmm2
    mulsd xmm0, xmm3
    mulsd xmm0, xmm4

    movsd [rdi], xmm0

    ; epilogo
    pop rbp
    ret


