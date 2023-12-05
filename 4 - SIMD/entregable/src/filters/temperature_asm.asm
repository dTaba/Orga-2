PX_OFFSET EQU 4
FIRST_T_LIMIT: EQU 32
SECOND_T_LIMIT: EQU 96
THIRD_T_LIMIT: EQU 160
FOURTH_T_LIMIT: EQU 224

global temperature_asm

section .data
mask_clean_transparency: db 0xFF, 0xFF, 0xFF, 0x0, 0xFF, 0xFF, 0xFF, 0x0
mask_to_divide: dq 3.0, 3.0
limit_mask: db 32, 96, 160, 224
;first_and_fifth_case_mask: db 0x000000FF
;second_case_mask: db 0x0000FFFF
;third_case_mask: db 0x00FF00FF
;fourth_case_mask: db 0xFF0000FF

section .text
;void temperature_asm(unsigned char *src,
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

temperature_asm:
	push rbp
	mov rbp, rsp

    ;save the const values in registries
    MOVQ xmm1, [mask_clean_transparency]
    MOVDQU xmm2, [mask_to_divide]
    MOVD xmm3, [limit_mask]

    shr rdx, 1	; Voy a procesar de a 2 pixeles, por lo que divido la cantidad de columnas por 2

	.loop_fila:
		mov r15, rcx	; Guardo la cantidad de filas que faltan procesar en un registro auxiliar
		mov rcx, rdx	; Reseteo la cantidad de columnas que faltan procesar
		.loop_columna:
            
            MOVQ xmm0, [rdi];get the two first pixels => r1 | g1 | b1 | t1 | r2 | g2 | b2 | t2 [byte]
            PAND xmm0, xmm1;delete the transparency => r1 | g1 | b1 | 0 | r2 | g2 | b2 | 0 [byte]
            PMOVZXBW xmm0, xmm0;double the size of the bytes to words  => r1 | g1 | b1 | 0 | r2 | g2 | b2 | 0 [word]
            PHADDW xmm0, xmm0;horizontal add => rg1|b1|rg2|b2 [word]
            PMOVZXWD xmm0, xmm0;double the size again => rg1|b1|rg2|b2 [dwords]
            PHADDD xmm0, xmm0;again horizontal add to get rgb1|rgb2 [dw]
            CVTDQ2PD xmm0, xmm0;double the size => rgb1|rgb2 [qword]
            DIVPD xmm0, xmm2;divide by 3, now we got rgb1/3|rgb2/3 => t1|t2 [qword]

            CVTTPD2DQ xmm0, xmm0; trunco a integer doubleword
            PEXTRD r10d, xmm0, 0; me guardo t1 en r10
            ; comparo todos los casos y cuando entra salta a la transformacion correspondiente
            PEXTRB r12, xmm3, 0
            CMP r12, r10
            JG .firstCaseColorT1

            PEXTRB r12, xmm3, 1
            CMP r12, r10
            JG .secondCaseColorT1

            PEXTRB r12, xmm3, 2
            CMP r12, r10
            JG .thirdCaseColorT1

            PEXTRB r12, xmm3, 3
            CMP r12, r10
            JG .fourthCaseColorT1

            ;else
            SUB r10d, 224
            SHL r10d, 2
            NEG r10d
            ADD r10d, 255
            SHL r10d, 16
            XOR r10d, 0xFF000000
            JMP .nextPixelT1

            .firstCaseColorT1:
            SHL r10d, 2
            ADD r10d, 128
            XOR r10d, 0xFF000000
            JMP .nextPixelT1

            .secondCaseColorT1:
            SUB r10d, 32
            SHL r10d, 2
            SHL r10d, 8
            XOR r10d, 0xFF0000FF
            JMP .nextPixelT1

            .thirdCaseColorT1:
            SUB r10d, 96
            SHL r10d, 2
            MOV r14d, r10d
            NEG r14d
            ADD r14d, 255
            SHL r10d, 16
            OR r10d, r14d
            XOR r10d, 0xFF00FF00
            JMP .nextPixelT1

            .fourthCaseColorT1:
            SUB r10d, 160
            SHL r10d, 2
            NEG r10d
            ADD r10d, 255
            SHL r10d, 8
            XOR r10d, 0xFFFF0000

            .nextPixelT1:

            PEXTRD r11d, xmm0, 1; me guardo t2 en r11
            ; comparo todos los casos y cuando entra salta a la transformacion correspondiente
            PEXTRB r12, xmm3, 0
            CMP r12, r11
            JG .firstCaseColorT2

            PEXTRB r12, xmm3, 1
            CMP r12, r11
            JG .secondCaseColorT2

            PEXTRB r12, xmm3, 2
            CMP r12, r11
            JG .thirdCaseColorT2

            PEXTRB r12, xmm3, 3
            CMP r12, r11
            JG .fourthCaseColorT2

            ;else
            SUB r11d, 224
            SHL r11d, 2
            NEG r11d
            ADD r11d, 255
            SHL r11d, 16
            XOR r11d, 0xFF000000
            JMP .nextPixelT2

            .firstCaseColorT2:
            SHL r11d, 2
            ADD r11d, 128
            XOR r11d, 0xFF000000
            JMP .nextPixelT2

            .secondCaseColorT2:
            SUB r11d, 32
            SHL r11d, 2
            SHL r11d, 8
            XOR r11d, 0xFF0000FF
            JMP .nextPixelT2

            .thirdCaseColorT2:
            SUB r11d, 96
            SHL r11d, 2
            MOV r14d, r11d
            NEG r14d
            ADD r14d, 255
            SHL r11d, 16
            OR r11d, r14d
            XOR r11d, 0xFF00FF00
            JMP .nextPixelT2

            .fourthCaseColorT2:
            SUB r11d, 160
            SHL r11d, 2
            NEG r11d
            ADD r11d, 255
            SHL r11d, 8
            XOR r11d, 0xFFFF0000

            .nextPixelT2:

            SHL r11, 32
            OR r11, r10
            MOVQ xmm0, r11

            ; Escribo los 2 pixeles procesados
			movq [rsi], xmm0
			
            ; Avanzo 2 pixeles
            add rsi, 2 * PX_OFFSET
            add rdi, 2 * PX_OFFSET

        SUB rcx, 1
        CMP rcx, 0
        jnz .loop_columna
        ; Recuerdo la cantidad de filas que faltan procesar para loopear correctamente.
		mov rcx, r15
    SUB rcx, 1
    CMP rcx, 0
	jnz .loop_fila

	pop rbp
    ret
