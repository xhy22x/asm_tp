global _start

section .bss
	buffer resb 256

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jl error

	mov rsi, [rsp+16]
	mov rdx, buffer
	xor rcx, rcx
	jmp loop

	loop:
	cmp byte [rsi], 0
	je end
	mov al, [rsi]
	mov byte [rdx], al
	inc rsi
	inc rdx
	inc rcx
	jmp loop

	end:
	mov byte [rdx], 0x0A
	inc rcx

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, rcx
	syscall

	mov rax, 60
	xor edi, edi
	syscall

	error:
	mov rax, 60
	mov edi, 1
	syscall
