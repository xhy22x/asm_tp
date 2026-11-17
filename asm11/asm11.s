global _start

section .bss
	input resb 4096
	output resb 256

section .text
_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 4096
	syscall

	mov r8, rax
	xor r9, r9
	xor r10, r10
	call check_vowels
	call convert
	jmp end

	check_vowels:
	cmp r9, r8
	je call_end
	cmp byte [rsi], 0x61
	je count
	cmp byte [rsi], 0x65
	je count
	cmp byte [rsi], 0x69
	je count
	cmp byte [rsi], 0x6F
	je count
	cmp byte [rsi], 0x75
	je count
	cmp byte [rsi], 0x41
	je count
	cmp byte [rsi], 0x45
	je count
	cmp byte [rsi], 0x49
	je count
	cmp byte [rsi], 0x4F
	je count
	cmp byte [rsi], 0x55
	je count
	inc rsi
	inc r9
	jmp check_vowels

	count:
	inc r9
	inc rsi
	inc r10
	jmp check_vowels

	call_end:
	ret

	convert:
	mov rax, r10
	xor r8, r8
	convert_loop:
	xor rdx, rdx
	mov rcx, 10
	div rcx
	add dl, '0'
	push rdx
	inc r8
	test rax, rax
	jnz convert_loop

	mov rdi, output
	mov rcx, r8
	write_loop:
	pop rax
	mov [rdi], al
	inc rdi
	loop write_loop

	mov byte [rdi], 0x0A
	inc r8
	ret

	end:
	mov rax, 1
	mov rdi, 1
	mov rsi, output
	mov rdx, r8
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
