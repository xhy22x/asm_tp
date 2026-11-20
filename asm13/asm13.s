global _start

section .bss
	input resb 4096

section .text
_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 4096
	syscall

	xor r8, r8
	xor r9, r9
	call count

	cmp r8, 0
	je end
	cmp byte [rsi+r8-1], 0x0A
	jne no_newline
	dec r8
	no_newline:
	cmp r8, 0
	je end

	mov r10, r8
	mov rax, r8
	xor rdx, rdx
	mov rbx, 2
	div rbx
	cmp rdx, 0
	je even
	inc rax
	even:
	mov r9, rax
	xor r8, r8
	jmp save_half

	call_end:
	ret

	count:
	cmp byte [rsi+r8], 0
	je call_end
	inc r8
	jmp count

	save_half:
	cmp r8, r9
	jge start_compare
	movzx rax, byte [rsi+r8]
	push rax
	inc r8
	jmp save_half

	start_compare:
	mov r8, r10
	sub r8, r9
	compare:
	cmp r9, 0
	je end
	pop rax
	cmp al, byte [rsi+r8]
	jne not_palindrome
	inc r8
	dec r9
	jmp compare

	not_palindrome:
	mov rax, 60
	mov rdi, 1
	syscall

	end:
	mov rax, 60
	xor rdi, rdi
	syscall

