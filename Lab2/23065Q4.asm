[org 0x0100]

    mov bx, [num]
    mov cx, [num]
    mov ax, 0

square_loop:
    add ax, [num]
    sub cx, 1
    jnz square_loop

    mov dx, ax
    mov cx, [num]
    mov ax, 0

cube_loop:
    add ax, dx
    sub cx, 1
    jnz cube_loop

    mov [result], ax

    mov ax, 0x4c00
    int 0x21

num: dw 5
result: dw 0