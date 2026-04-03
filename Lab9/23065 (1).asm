[org 0x100]
jmp start

block1: db 1, 2, 3, 4, 5
block2: db 1, 2, 3, 4, 5

start:
    mov ax, block1
    push ax
    mov ax, block2
    push ax
    mov ax, 5
    push ax
    call memcompare
    
    mov ax, 0x4C00
    int 0x21

memcompare:
    push bp
    mov bp, sp
    push si
    push di
    push cx

    mov si, [bp+8]
    mov di, [bp+6]
    mov cx, [bp+4]

cmp_loop:
    mov al, [si]
    cmp al, [di]
    jne mismatch
    inc si
    inc di
    loop cmp_loop

    mov ax, 0
    jmp cmp_done

mismatch:
    mov ax, 1

cmp_done:
    pop cx
    pop di
    pop si
    pop bp
    ret 6
