extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	push rbp
	mov rbp, rsp

	.iterarCadena:
		mov r8b, [rdi]
		cmp r8b, [rsi]


		jl .devolverUno ; a > b
		jg .devolverMenosUno ; a < b
		
		xor rax, rax
		
		cmp r8b, 0
		jz .devolverCMP
		add rdi, 1
		add rsi, 1
		jmp .iterarCadena

	.devolverUno:
		mov rax, 1
		jmp .devolverCMP

	.devolverMenosUno:
		mov rax, -1	
		jmp .devolverCMP

	.devolverCMP:
	
	pop rbp
	ret

; char* strClone(char* a)
strClone:

	;epilogo
	push rbp
	mov rbp, rsp

	call strLen ; Guardo en rax los bytes de la palabra
	add rax, 0x1 ; Le sumo el caracter nulo


	push rdi ; Guardo rdi en el stack
	sub rsp, 8 ; Alineo el stack a 16 para llamar a malloc

	mov rdi, rax ; Guardo en rlos bytes de la palabra
	call malloc WRT ..plt; rax = *(donde empieza mi espacio)

	mov r9, rax

	add rsp, 8
	pop rdi ; Restauro rdi que tiene puntero a la palabra

	.startwhileClone: ;while [rdi] != 0 then
		mov r8b, [rdi]
		mov [r9], r8b
		cmp r8b, 0x0
		jz .endwhileClone
		add rdi, 1
		add r9, 1
		jmp .startwhileClone
	.endwhileClone:

	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	push rbp
	mov rbp, rsp

	call free WRT ..plt

	pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	push rbp
	mov rbp, rsp

	xor rax, rax ;rax = 0
	cmp rdi, 0x0
	jnz .startwhile

	.printnull:
		mov byte [rsi], 'N'
		mov byte [rsi + 1], 'U'
		mov byte [rsi + 2], 'L'
		mov byte [rsi + 3], 'L'
		jmp .endwhile
	
	.startwhile: ;while rdi != 0 then
		mov r8, [rdi]
		mov [rsi], r8
		cmp rdi, 0x0
		jz .endwhile
		add rdi, 1 ;
		add rsi, 1 ;
		jmp .startwhile
	.endwhile:

	pop rbp
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp, rsp
	push rdi

	xor rax, rax ;rax = 0
	
	.startwhileLen: ;while rdi != 0 then
		cmp byte [rdi], 0x0
		jz .endwhileLen
		add rdi, 1 ;
		add rax, 1 ;sumamos 1
		jmp .startwhileLen
	.endwhileLen:

	pop rdi
	pop rbp
	ret


