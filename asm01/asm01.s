global _start

section .data
	msg db "1337", 10

section .text
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 5
	syscall

	mov rax, 60
	xor edi, edi
	syscall
