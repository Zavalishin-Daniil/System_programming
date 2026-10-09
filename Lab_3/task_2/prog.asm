format ELF64
public _start

section '.data' writable
    place db ?

section '.text' executable

_start:
    mov rsi, [rsp+16]
    call str_number         ; rax = a
    mov r12, rax

    mov rsi, [rsp+24]
    call str_number         ; rax = b
    mov r13, rax

    mov rsi, [rsp+32]
    call str_number         ; rax = c
    mov r14, rax

    mov rax, r12            ; a
    cqo
    idiv r13                ; a/b
    sub rax, r12            ; a/b - a
    cqo
    idiv r13                ; (a/b - a)/b
    imul rax, r14           ; * c
    add rax, r12            ; + a

    call print_number
    mov rax, 0xA
    call print_symbol
    call exit


str_number:
    xor rax, rax
    xor rcx, rcx
.loop:
    xor rbx, rbx
    mov bl, byte [rsi+rcx]
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .done
    sub bl, '0'
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rcx
    jmp .loop
.done:
    cmp rcx, 0
    je .ret
    mov rbx, 10
    div rbx
.ret:
    ret


; rax -> на экран (десятичное число, со знаком)
print_number:
    cmp rax, 0
    jge .pos
    push rax
    mov rax, '-'
    call print_symbol
    pop rax
    neg rax
.pos:
    mov rcx, 10
    xor rbx, rbx
    cmp rax, 0
    jne .l1
    mov rax, '0'
    call print_symbol
    ret
.l1:
    xor rdx, rdx
    div rcx
    add rdx, '0'
    push rdx
    inc rbx
    cmp rax, 0
    jne .l1
.l2:
    pop rax
    call print_symbol
    dec rbx
    cmp rbx, 0
    jne .l2
    ret


; al -> на экран
print_symbol:
    mov [place], al
    mov rax, 1
    mov rdi, 1
    mov rsi, place
    mov rdx, 1
    syscall
    ret


exit:
    mov rax, 60
    xor rdi, rdi
    syscall
