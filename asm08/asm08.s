global _start

section .bss
	reverse resb 256
	output resb 256

section .text
_start:
	mov rax, [rsp]
	cmp rax, 2
	jne error_arg

	mov rsi, [rsp+16]
	call ignore
	cmp byte [rsi], 0
	je error

	xor r9, r9
	call check_negative

	xor rdi, rdi
	call convert_digit
	call if_negative

	xor r8, r8
	xor rcx, rcx
	call sum_integers
	mov rax, rcx
	xor r8, r8
	mov rcx, 10
	mov rdi, reverse
	call convert_reverse
	mov rcx, output
	call reverse_buffer
	jmp success

	ignore:
	cmp byte [rsi], 0x20
	jne call_end
	inc rsi
	jmp ignore

	call_end:
	ret

	check_negative:
	cmp byte [rsi], '-'
	jne call_end
	mov r9, 1
	inc rsi
	ret

	if_negative:
	cmp r9, 1
	jne call_end
	mov rcx, output
	mov byte [rcx], 0x30
	inc rcx
	inc r8
	jmp success

	convert_digit:
	cmp byte [rsi], 0
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

	sum_integers:
	cmp r8, rdi
	jge call_end
	add rcx, r8
	jo error
	inc r8
	jmp sum_integers

	convert_reverse:
	xor rdx, rdx
	div rcx
	add dl, '0'
	mov byte [rdi], dl
	inc rdi
	inc r8
	test rax, rax
	jnz convert_reverse
	ret

	reverse_buffer:
	dec rdi
	cmp byte [rdi], 0
	je call_end
	mov al, byte [rdi]
	mov byte [rcx], al
	inc rcx
	jmp reverse_buffer

	success:
	mov byte [rcx], 0x0A
	inc r8

	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, r8
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

	error:
	mov rax, 60
	mov rdi, 1
	syscall

	error_arg:
	mov rax, 60
	mov rdi, 2
	syscall
