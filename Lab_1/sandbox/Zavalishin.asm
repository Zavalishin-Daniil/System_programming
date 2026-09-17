format ELF

public _start

section '.text' executable
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, surname
    mov edx, surname_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, name_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, patronymic
    mov edx, patronymic_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

section '.data' writeable

surname        db 'Завалишин', 10
surname_len    = $ - surname

name           db 'Даниил', 10
name_len       = $ - name

patronymic     db 'Евгеньевич', 10
patronymic_len = $ - patronymic
