[org 0x100]
jmp start

data:    db 10101000b
pattern: dw 101b

start:
    mov ax, data
    push ax
    mov ax, 1
    push ax
    mov ax, 101b
    push ax
    mov ax, 3
    push ax
    call bitsearch

    mov ax, 0x4C00
    int 0x21

bitsearch:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp+10]
    mov bx, [bp+8]
    mov dx, [bp+6]
    mov cx, [bp+4]

    xor ah, ah
    mov al, bl
    mov bl, 8
    mul bl
    xor bh, bh
    mov bl, cl
    sub ax, bx
    inc ax
    mov bx, ax

    xor di, di

search_loop:
    call extract_bits
    cmp ax, dx
    je found
    inc di
    dec bx
    jnz search_loop
    xor ax, ax
    jmp search_done

found:
    mov ax, di
    inc ax

search_done:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop bp
    ret 8

extract_bits:
    push bx
    push cx
    push dx
    push si
    push di

    xor bx, bx
    mov ch, cl
    xor cl, cl

next_bit:
    cmp cl, ch
    jge eb_done

    mov ax, di
    shr ax, 3
    mov bx, si
    add bx, ax
    mov al, [bx]

    mov dx, di
    and dl, 7
    mov dh, 7
    sub dh, dl
    push cx
    mov cl, dh
    shr al, cl
    pop cx
    and al, 1

    shl bx, 1
    or bl, al

    inc di
    inc cl
    jmp next_bit

eb_done:
    mov ax, bx

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret