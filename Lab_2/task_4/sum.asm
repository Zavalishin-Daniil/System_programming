format ELF64

public _start
public exit
public print_symbol

NUMBER equ 2634342072
TEN    equ 10
NUL    equ '0'
N      equ 32

section '.data' writable
    newline db 0xA
    place   db 1

section '.bss' writable
    buffer db N dup (?)

section '.text' executable

_start:
    mov eax, NUMBER
    xor ebx, ebx

.sum_loop:
    xor edx, edx
    mov ecx, TEN
    div ecx
    add ebx, edx
    test eax, eax
    jnz .sum_loop

    lea edi, [buffer + N]
    mov eax, ebx
    mov ecx, TEN

.convert_loop:
    xor edx, edx
    div ecx
    add dl, NUL
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .convert_loop

    lea edx, [buffer + N]
    sub edx, edi

.print_loop:
    mov al, [edi]
    push rdi
    push rdx
    call print_symbol
    pop rdx
    pop rdi
    inc edi
    dec edx
    jnz .print_loop

    mov al, 0xA
    call print_symbol

    call exit

print_symbol:
    push rbx
    push rdx
    push rcx
    push rax
    push rax
    mov eax, 4
    mov ebx, 1
    pop rdx
    mov [place], dl
    mov ecx, place
    mov edx, 1
    int 0x80
    pop rax
    pop rcx
    pop rdx
    pop rbx
    ret

exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
