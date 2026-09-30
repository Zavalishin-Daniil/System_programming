format ELF64

public _start
public exit
public print_symbol

N    equ 153
CHAR equ '$'

section '.data' writable
    newline db 0xA
    place   db 1

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
    mov rbx, 1
.row_loop:
    mov rax, rcx
    add rax, rbx
    cmp rax, N
    jg  .done

    push rcx
    push rbx
    xor rdx, rdx
.col_loop:
    mov al, [buffer + rcx + rdx]
    push rcx
    push rdx
    call print_symbol
    pop rdx
    pop rcx
    inc rdx
    cmp rdx, rbx
    jne .col_loop
    pop rbx
    pop rcx

    mov al, 0xA
    call print_symbol

    add rcx, rbx
    inc rbx
    jmp .row_loop

.done:
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
