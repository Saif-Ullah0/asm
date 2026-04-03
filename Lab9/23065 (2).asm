[org 0x100]

start:
    mov ax, 10
    mov bx, 20

    mov cx, after_add
    push cx
    jmp do_add

after_add:
    mov ax, 0x4C00
    int 0x21

do_add:
    add ax, bx
    
    pop cx
    jmp cx
