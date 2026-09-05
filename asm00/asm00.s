global _start

section .text
_start:
	mov rax, 60
	xor edi, edi
	syscall
