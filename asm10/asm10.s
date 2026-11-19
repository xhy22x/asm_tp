global _start

section .bss
	buffer resb 256
	output resb 256

section .text
_start:
	mov rax, [rsp]
	cmp rax, 4
	jne error_arg

	xor r9, r9
	xor r10, r10
	mov rbx, [rsp + 16]
	call compare
	mov rbx, [rsp + 24]
	call compare
	mov rbx, [rsp + 32]
	call compare
	jmp end

	call_end:
	ret

	if_negative:
	cmp byte [rbx], 0x2D
	jne call_end
	mov r8, 1
	inc rbx
	ret

	compare:
	xor r8, r8
	xor rdi, rdi

	call if_negative
	cmp byte [rbx], 0
	je error_number
	call convert_to_digit

	cmp r10, 0
	je save

	cmp r9, rdi
	jl save
	ret
	save:
	mov r9, rdi
	mov r10, 1
	ret

	convert_to_digit:
	cmp byte [rbx], 0
	je call_end
	cmp byte [rbx], 0x30
	jl error_number
	cmp byte [rbx], 0x39
	jg error_number

	movzx rax, byte [rbx]
	sub rax, '0'
	imul rdi, rdi, 10
	jo error_number

	inc rbx

	test r8, r8
	jnz negative
	add rdi, rax
	jo error_number
	jmp convert_to_digit
	negative:
	sub rdi, rax
	jo error_number
	jmp convert_to_digit

	convert_to_string:
	xor rdx, rdx
	div rcx
	add dl, '0'
	mov byte [rdi], dl
	inc rdi
	inc r8
	test rax, rax
	jnz convert_to_string

	mov rsi, output
	test r10, r10
	jz reverse_buffer
	mov byte [rsi], 0x2D
	inc rsi
	jmp reverse_buffer

	reverse_buffer:
	dec rdi
	cmp byte [rdi], 0
	je call_end
	mov al, byte [rdi]
	mov byte [rsi], al
	inc rsi
	jmp reverse_buffer

	error_arg:
	mov rax, 60
	mov rdi, 2
	syscall

	error_number:
	mov rax, 60
	mov rdi, 1
	syscall

	end:
	mov rax, r9
	mov rcx, 10
	mov rdi, buffer

	xor r8, r8
	xor r10, r10
	test rax, rax
	jns positive
	mov r10, 1
	neg rax
	positive:
	call convert_to_string

	test r10, r10
	jz write
	inc r8

	write:
	mov byte [rsi], 0x0A
	inc r8

	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, r8
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
