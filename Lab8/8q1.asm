[org 0x100]
jmp start

data: dw 1, 2, 3, 4, 5

start:
    mov ax, data
    push ax
    mov ax, 5
    push ax
    call reverse
    
    mov ax, 0x4C00
    int 0x21

reverse:
    push bp
    mov bp, sp
    push bx
    push cx
    push si

    mov bx, [bp+6]
    mov cx, [bp+4]

    mov si, 0
    mov dx, cx

push_loop:
    push word [bx+si]
    add si, 2
    loop push_loop

    mov si, 0
    mov cx, dx

pop_loop:
    pop word [bx+si]
    add si, 2
    loop pop_loop

    pop si
    pop cx
    pop bx
    mov sp, bp
    pop bp
    ret 4