format ELF64

public _start

section '.data' writable
    place db ?          ; буфер для вывода одного символа

section '.text' executable

_start:
    ; Получаем адрес первого аргумента командной строки.
    ; В стеке: [rsp] = argc, [rsp+8] = argv[0], [rsp+16] = argv[1]
    mov rsi, [rsp + 16]     ; rsi = адрес строки-аргумента

    ; Загружаем сам символ (первый байт строки) в rax.
    xor rax, rax
    mov al, byte [rsi]      ; al = ASCII-код символа

    ; rax = число (код символа), выводим его
    call print_number

    ; Переводим строку
    mov rax, 0xA
    call print_symbol

    ; Завершаем программу
    call exit


; ------------------------------------------------------------
; print_number: выводит число из rax в десятичном виде
; Использует стек для хранения цифр (как в лекции 3)
; ------------------------------------------------------------
print_number:
    push rbx
    push rcx
    push rdx
    push rax

    mov rcx, 10             ; делитель
    xor rbx, rbx            ; счётчик цифр

    ; Если rax == 0, сразу выводим '0'
    cmp rax, 0
    jne .iter1
    mov rax, '0'
    call print_symbol
    jmp .restore

.iter1:
    xor rdx, rdx            ; rdx:rax / 10
    div rcx                 ; rax = частное, rdx = остаток
    add rdx, '0'            ; превращаем цифру в символ
    push rdx                ; сохраняем цифру в стек
    inc rbx                 ; увеличиваем счётчик
    cmp rax, 0
    jne .iter1

.iter2:
    pop rax                 ; достаём цифру
    call print_symbol
    dec rbx
    cmp rbx, 0
    jne .iter2

.restore:
    pop rax
    pop rdx
    pop rcx
    pop rbx
    ret


; ------------------------------------------------------------
; print_symbol: выводит символ из rax (младший байт)
; ------------------------------------------------------------
print_symbol:
    push rbx
    push rdx
    push rcx
    push rax

    mov [place], al         ; сохраняем символ в буфер
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, place          ; адрес буфера
    mov edx, 1              ; 1 байт
    int 0x80                ; системный вызов (Linux)

    pop rax
    pop rcx
    pop rdx
    pop rbx
    ret


; ------------------------------------------------------------
; exit: завершение программы
; ------------------------------------------------------------
exit:
    mov eax, 1              ; sys_exit
    mov ebx, 0              ; код возврата 0
    int 0x80
