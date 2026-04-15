[org 0x0100]
jmp start

nibblemirror:
    push bp
    mov bp, sp
    push bx
    push cx

    mov bx, [bp+4]

    mov al, bl
    and al, 0x0F

    mov ah, 0
    mov cx, 4

nm_loop:
    shl ah, 1
    shr al, 1
    adc ah, 0
    loop nm_loop

    and bl, 0x0F
    shl ah, 4
    or bl, ah

    mov ax, bx

    pop cx
    pop bx
    pop bp
    push ax
    ret 2

start:
    mov ax, 0x0005
    push ax
    call nibblemirror
    pop ax        ; AX = 00A5

    mov ax, 0x4C00
    int 0x21