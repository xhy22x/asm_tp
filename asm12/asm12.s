global _start

section .bss
	input resb 4096
	output resb 1

section .text
_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 4096
	syscall

	xor r8, r8
	jmp loop

	call_end:
	ret

	loop:
	cmp byte [rsi], 0
	je print
	cmp byte [rsi], 0x0A
	je print

	movzx rax, byte [rsi]
	push rax

	inc rsi
	inc r8
	jmp loop

	print:
	cmp r8, 0
	je newline

	pop rax
	mov [output], al

	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, 1
	syscall

	dec r8
	jmp print

	newline:
	mov byte [output], 0x0A
	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, 1
	syscall

	end:
	mov rax, 60
	mov rdi, 0
	syscall
