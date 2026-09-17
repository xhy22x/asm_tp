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

	call ignore

	cmp byte [rsi], 0x0A
	je error

	xor r9, r9
	cmp byte [rsi], '-'
	je negative
	jmp conv

	negative:
	mov r9, 1
	inc rsi
	jmp conv

	conv:
	xor rdi, rdi
	call convert_digit
	cmp rdi, 2
	jl error
	mov r8, 2
	call if_prime

	ignore:
	cmp byte [rsi], 0x20
	jne call_end
	inc rsi
	jmp ignore

	convert_digit:
	cmp byte [rsi], 0x0A
	je call_end
	cmp byte [rsi], 0x30
	jb error
	cmp byte [rsi], 0x39
	ja error

	movzx rax, byte [rsi]
	sub rax, '0'
	imul rdi, rdi, 10
	jo error
	add rdi, rax
	jo error
	inc rsi
	jmp convert_digit

	call_end:
	ret

	if_prime:
	cmp r9, 1
	je not_prime
	cmp r8, rdi
	je prime

	mov rax, rdi
	xor rdx, rdx
	mov rcx, r8
	div rcx

	test rdx, rdx
	je not_prime

	inc r8
	jmp if_prime

	prime:
	mov rax, 60
	mov rdi, 0
	syscall

	not_prime:
	mov rax, 60
	mov rdi, 1
	syscall

	error:
	mov rax, 60
	mov rdi, 2
	syscall

