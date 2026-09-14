global _start

section .bss
	buffer resb 256

section .text
_start:
	mov rax, [rsp]
	cmp rax, 3
	jne error

	mov rsi, [rsp+16]
	xor rcx, rcx
	call convert_digit
	mov rbx, rcx

	mov rsi, [rsp+24]
	xor rcx, rcx
	call convert_digit
	add rbx, rcx

	mov rax, rbx
	mov rcx, 10

	lea rdi, [buffer+255]
	mov byte [rdi], 10
	call convert_display
	jmp end

	convert_digit:
	cmp byte [rsi], 0
	je convert_end
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
	dec rdi
	mov byte [rdi], dl
	test rax, rax
	jnz convert_display

	convert_end:
	ret

	end:
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 256
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

	error:
	mov rax, 60
	mov rdi, 1
	syscall
