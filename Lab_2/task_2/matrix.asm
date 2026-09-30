format ELF64

public _start
public exit
public print_symbol

N    equ 153
M    equ 9
K    equ 17
CHAR equ '$'

section '.data' writable
    place db 1

section '.bss' writable
    buffer db N dup (?)

section '.text' executable

_start:
    xor rcx, rcx
.fill_loop:
    mov al, CHAR
    mov [buffer + rcx], al
    inc rcx
    cmp rcx, N
    jne .fill_loop

    xor rcx, rcx
.print_loop:
    mov al, [buffer + rcx]
    call print_symbol
    inc rcx
    mov rax, rcx
    xor rdx, rdx
    mov rbx, M
    div rbx
    cmp rdx, 0
    jne .no_newline
    mov al, 0xA
    call print_symbol
.no_newline:
    cmp rcx, N
    jne .print_loop

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
