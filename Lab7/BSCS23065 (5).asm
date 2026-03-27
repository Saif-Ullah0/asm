[org 0x100]

start:
    mov ax, 0ABD5h
    xor bx, bx
    mov dl, 0

check_loop:
    mov si, ax
    mov cl, dl
    shr si, cl
    and si, 7
    cmp si, 5
    jne next
    inc bx

next:
    inc dl
    cmp dl, 14
    jl check_loop

    mov cx, bx

    mov ax, 0x4C00
    int 0x21