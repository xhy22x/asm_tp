global _start

section .data
	msg db "1337", 10

section .text
_start:

	mov rdi, [rsp]
	cmp rdi, 2
	jne error_arg

	mov rsi, [rsp+16]
	cmp byte [rsi], 0x34
	jne error
	cmp byte [rsi+1], 0x32
	jne error
	cmp byte [rsi+2], 0
	jne error

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

	error_arg:
	mov rax, 60
	mov edi, 2
	syscall
