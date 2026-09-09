global _start

section .bss
	buffer resb 256

section .text
_start:
	mov rdi, [rsp]
	cmp rdi, 2
	jne error
	mov rsi, [rsp+16]
	mov rdx, buffer
	jmp loop

	loop:
	cmp byte [rsi], 0
	je end
	mov al, [rsi]
	mov byte [rdx], al
	inc rsi
	inc rdx
	jmp loop

	end:
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 256
	syscall

	mov rax, 60
	xor edi, edi
	syscall

	error:
	mov rax, 60
	mov edi, 1
	syscall
