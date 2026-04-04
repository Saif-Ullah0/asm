[org 0x100]
jmp start

start:
    mov ax, 1234h
    push ax
    call bitswap

    pop ax
    
    mov ax, 0x4C00
    int 0x21

bitswap:
    push bp
    mov bp, sp
    sub sp, 2
    push ax
    push bx
    push cx

    mov ax, [bp+4]
    mov [bp-2], ax

    call swapbits_1_15
    call swapbits_3_13
    call swapbits_5_11
    call swapbits_7_9

    mov ax, [bp-2]
    mov [bp+4], ax

    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

swapbits_1_15:
    push ax
    push bx
    mov ax, [bp-2]
    mov bx, ax
    shr bx, 14
    xor bx, ax
    and bx, 0002h
    xor ax, bx
    mov bx, ax
    shl bx, 14
    xor bx, ax
    and bx, 8000h
    xor ax, bx
    mov [bp-2], ax
    pop bx
    pop ax
    ret

swapbits_3_13:
    push ax
    push bx
    mov ax, [bp-2]
    mov bx, ax
    shr bx, 10
    xor bx, ax
    and bx, 0008h
    xor ax, bx
    mov bx, ax
    shl bx, 10
    xor bx, ax
    and bx, 2000h
    xor ax, bx
    mov [bp-2], ax
    pop bx
    pop ax
    ret

swapbits_5_11:
    push ax
    push bx
    mov ax, [bp-2]
    mov bx, ax
    shr bx, 6
    xor bx, ax
    and bx, 0020h
    xor ax, bx
    mov bx, ax
    shl bx, 6
    xor bx, ax
    and bx, 0800h
    xor ax, bx
    mov [bp-2], ax
    pop bx
    pop ax
    ret

swapbits_7_9:
    push ax
    push bx
    mov ax, [bp-2]
    mov bx, ax
    shr bx, 2
    xor bx, ax
    and bx, 0080h
    xor ax, bx
    mov bx, ax
    shl bx, 2
    xor bx, ax
    and bx, 0200h
    xor ax, bx
    mov [bp-2], ax
    pop bx
    pop ax
    ret