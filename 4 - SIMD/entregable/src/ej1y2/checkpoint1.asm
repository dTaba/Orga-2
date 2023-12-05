
section .text

global invertirQW_asm

; void invertirQW_asm(uint64_t* p)
; rdi 64bits - uint64_t*  
; quadword 64 bits
; movq
invertirQW_asm:
	push rbp
	mov rbp, rsp

	; Traigo ambas Quadwords
	movdqu xmm0, [rdi]

	; Las invierto sobre xmm1
	movhlps xmm1, xmm0	; MOV from H (High part) to L (Low part)
	movlhps xmm1, xmm0	; MOV from L (Low part) to H (High part)

	; Las devuelvo
	movdqu [rdi], xmm1

	pop rbp
	ret

