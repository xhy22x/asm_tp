global _start

section .bss
	number resb 256

section .text
_start:

	mov rax, 0
	mov rdi, 0
	mov rsi, number
	mov rdx, 256
	syscall

	cmp byte [rsi], 0x2D
	jne loop
	inc rsi

	loop:
	cmp byte [rsi], 0x0A
	je end
	cmp byte [rsi], 0x30
	jl error
	cmp byte [rsi], 0x39
	jg error
	inc rsi
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
