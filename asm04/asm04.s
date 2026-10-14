global _start

section .bss
	input resb 256
	number resb 256

section .text
_start:

	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 256
	syscall

	call ignore

	cmp byte [rsi], 0x0A
	je error

	xor r8, r8
	cmp byte [rsi], 0x2D
	jne loop
	mov r8, 1
	inc rsi
	jmp loop

	ignore:
	cmp byte [rsi], 0x20
	jne call_end
	inc rsi
	jmp ignore

	call_end:
	ret

	loop:
	cmp byte [rsi], 0x0A
	je end
	cmp byte [rsi], 0x30
	jl error
	cmp byte [rsi], 0x39
	jg error

	movzx rax, byte [rsi]
	sub rax, '0'
	imul rdi, rdi, 10
	jo error

	inc rsi

	test r8, r8
	jnz negative
	positive:
	add rdi, rax
	jo error
	jmp loop
	negative:
	sub rdi, rax
	jo error
	jmp loop

	end:
	dec rsi
	mov al, [rsi]
	sub al, '0'
	xor ah, ah
	mov bl, 2
	div bl


	movzx edi, ah
	mov eax, 60
	syscall

	error:
	mov rax, 60
	mov rdi, 2
	syscall
