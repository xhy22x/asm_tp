global _start

section .data
	msg db "1337", 10

section .bss
	buffer resb 10

section .text
_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	mov rdx, 10
	syscall

	cmp byte [buffer], 0x34
	jne error
	cmp byte [buffer+1], 0x32
	jne error
	cmp byte [buffer+2], 0x0A
	jne error

	egal:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 5
	syscall

	mov rax, 60
	xor edi, edi
	syscall

	error:
	mov rax, 60
	mov edi, 1
	syscall
