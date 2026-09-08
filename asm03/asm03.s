global _start

section .data
	msg db "1337", 10

section .text
_start:
	
	mov rdi, [rsp]
	cmp rdi, 2
	jne fin

	mov rsi, [rsp+16]
	cmp byte [rsi], 0x34
	jne fin
	cmp byte [rsi+1], 0x32
	jne fin

	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 5
	syscall

	mov rax, 60
	xor edi, edi
	syscall

	fin:
	mov rax, 60
	mov edi, 1
	syscall
