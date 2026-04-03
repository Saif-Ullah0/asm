; Task 5: Safe memory swap using stack
[org 0x100]
jmp start

block1: db 1, 2, 3, 4, 5
block2: db 6, 7, 8, 9, 10

start:
    mov ax, block1
    push ax
    mov ax, block2
    push ax
    mov ax, 5
    push ax
    call memswap
    
    mov ax, 0x4C00
    int 0x21

memswap:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di

    mov si, [bp+8]
    mov di, [bp+6]
    mov cx, [bp+4]

    push cx
    mov bx, cx

push_loop:
    mov al, [si + bx - 1]
    xor ah, ah
    push ax
    dec bx
    jnz push_loop
    pop cx

    push cx
    mov si, [bp+8]
    mov di, [bp+6]

copy_loop:
    mov al, [di]
    mov [si], al
    inc si
    inc di
    loop copy_loop
    pop cx

    mov si, [bp+8]
    mov di, [bp+6]

pop_loop:
    pop ax
    mov [di], al
    inc di
    loop pop_loop

    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
