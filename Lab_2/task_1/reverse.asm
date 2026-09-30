format ELF64
public _start

section '.data' writable
    msg     db 'eWTAqhRYsHMleIYxtfCbeQoDvnQaKdRkKzJboR', 0
    newline db 0xA, 0
    place   db ?

section '.text' executable

_start:
    mov rsi, msg
    xor rcx, rcx

.find_len:
    cmp byte [rsi + rcx], 0
    je  .got_len
    inc rcx
    jmp .find_len

.got_len:
    dec rcx
    mov rbx, rcx

.print_loop:
    mov al, [msg + rbx]
    mov [place], al

    push rbx
    mov eax, 4
    mov ebx, 1
    mov ecx, place
    mov edx, 1
    int 0x80
    pop rbx

    cmp rbx, 0
    je  .done
    dec rbx
    jmp .print_loop

.done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
