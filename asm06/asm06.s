global _start

section .bss
	buffer resb 256
	reverse resb 256

section .text
_start:
	mov rax, [rsp]
	cmp rax, 3
	jne error

	mov rsi, [rsp+16]
	xor rcx, rcx
	call conv
	mov rbx, rcx

	mov rsi, [rsp+24]
	xor rcx, rcx
	call conv
	add rbx, rcx

	xor r8, r8
	mov rdi, buffer
	mov rcx, 10

	test rbx, rbx
	js number_negative
	jmp number_positive

	conv:
	cmp byte [rsi], '-'
	je negative
	call convert_digit
	ret

	negative:
	inc rsi
	call convert_digit
	neg rcx
	ret

	number_positive:
	mov rax, rbx
	call convert_display
	mov rcx, reverse
	call reverse_buffer
	jmp end

	number_negative:
	neg rbx
	mov rax, rbx
	call convert_display
	mov rcx, reverse
	mov byte [rcx], '-'
	inc rcx
	inc r8
	call reverse_buffer
	jmp end

	convert_digit:
	cmp byte [rsi], 0
	je call_end
	cmp byte [rsi], 0x30
	jb error
	cmp byte [rsi], 0x39
	ja error

	movzx rax, byte [rsi]
	sub rax, '0'
	imul rcx, rcx, 10
	add rcx, rax
	inc rsi
	jmp convert_digit

	convert_display:
	xor rdx, rdx
	div rcx
	add dl, '0'
	mov byte [rdi], dl
	inc rdi
	inc r8
	test rax, rax
	jnz convert_display

	call_end:
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
	mov rax, 1
	mov rdi, 1
	mov rsi, reverse
	mov rdx, r8
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

	error:
	mov rax, 60
	mov rdi, 1
	syscall
