[org 0x0100]
jmp start

reverse_byte:
    push bp
    mov bp, sp
    push bx
    push cx

    mov bl, [bp+4]
    mov bh, 0
    mov cx, 8

rb_loop:
    shl bh, 1
    shr bl, 1
    adc bh, 0
    loop rb_loop

    mov al, bh
    mov ah, 0

    pop cx
    pop bx
    pop bp
    push ax
    ret 2

mirrorswap:
    push bp
    mov bp, sp
    push bx
    push cx

    mov ax, [bp+6]
    mov al, ah
    push ax
    call reverse_byte
    pop ax
    mov dl, al

    mov ax, [bp+4]
    push ax
    call reverse_byte
    pop ax
    mov dh, al

    pop cx
    pop bx
    pop bp
    push dx
    ret 4

start:
    mov ax, 0xAB12
    push ax
    mov ax, 0x34CD
    push ax
    call mirrorswap
    pop ax

    mov ax, 0x4C00
    int 0x21