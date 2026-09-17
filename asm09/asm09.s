global _start

section .bss
	reverse resb 256
	output resb 256

section .text
_start:
	xor r8, r8
	mov rsi, [rsp+16]
	mov rax, [rsp]
	cmp rax, 2
	je case_1
	cmp rax, 3
	je case_2
	jmp error

	ignore:
	cmp byte [rsi], 0x20
	jne call_end
	inc rsi
	jmp ignore

	ignore_end:
	inc rsi
	cmp byte [rsi], 0x20
	je ignore_end
	cmp byte [rsi], 0
	je call_end
	jmp error

	call_end:
	ret

	case_1:
	call ignore
	call convert_digit
	mov rax, rdi
	mov rcx, 16
	mov rdi, reverse
	call convert_hex
	mov rcx, output
	call reverse_buffer
	jmp end

	case_2:
	call ignore
	call check_binary_arg
	mov rsi, [rsp+24]
	call ignore
	call convert_digit
	mov rax, rdi
	mov rcx, 2
	mov rdi, reverse
	call convert_binary
	mov rcx, output
	call reverse_buffer
	jmp end

	convert_digit:
	cmp byte [rsi], 0
	je call_end
	cmp byte [rsi], 0x20
	je ignore_end
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

	convert_hex:
	xor rdx, rdx
	div rcx
	cmp dl, 9
	jle conv
	add dl, 7
	conv:
	add dl, '0'
	mov byte [rdi], dl
	inc rdi
	inc r8
	test rax, rax
	jnz convert_hex
	ret

	check_binary_arg:
	cmp byte [rsi], '-'
	jne error
	cmp byte [rsi+1], 'b'
	jne error
	cmp byte [rsi+2], 0
	jne error
	ret

	convert_binary:
	xor rdx, rdx
	div rcx
	add dl, '0'
	mov byte [rdi], dl
	inc rdi
	inc r8
	test rax, rax
	jnz convert_binary
	ret

	reverse_buffer:
	dec rdi
	cmp byte [rdi], 0
	je call_end
	mov al, byte [rdi]
	mov byte [rcx], al
	inc rcx
	jmp reverse_buffer

	end:
	mov byte [rcx], 0x0A
	inc r8

	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, r8
	syscall

	mov rax, 60
	xor edi, edi
	syscall

	error:
	mov rax, 60
	mov rdi, 1
	syscall
