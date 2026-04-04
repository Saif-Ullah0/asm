[org 0x100]
jmp start

start:
    mov ax, 0ABCDh
    call splitter
    
    mov ax, 0x4C00
    int 0x21

splitter:
    push cx
    push dx
    push si
    push di

    xor bx, bx
    xor si, si
    xor di, di
    mov cx, 16
    mov dx, ax

bit_loop:
    shr dx, 1
    jnc its_zero

its_one:
    mov ax, 16
    sub ax, cx
    test ax, 1
    jnz odd_bit

even_bit:
    push cx
    mov cx, si
    mov ax, 1
    shl ax, cl
    or bl, al
    pop cx
    inc si
    jmp next_bit

odd_bit:
    push cx
    mov cx, di
    mov ax, 1
    shl ax, cl
    or bh, al
    pop cx
    inc di
    jmp next_bit

its_zero:
    mov ax, 16
    sub ax, cx
    test ax, 1
    jnz inc_odd
    inc si
    jmp next_bit
inc_odd:
    inc di

next_bit:
    loop bit_loop

    pop di
    pop si
    pop dx
    pop cx
    ret