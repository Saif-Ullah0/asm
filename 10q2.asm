rotateleft:
    push bp
    mov bp, sp
    push cx

    mov ax, [bp+6]
    mov cx, [bp+4]

    cmp cx, 0
    je rl_done

rl_loop:
    rol ax, 1
    loop rl_loop

rl_done:
    pop cx
    pop bp
    push ax
    ret 4

rotateandcompare:
    push bp
    mov bp, sp
    push bx

    mov bx, [bp+6]

    push word [bp+6]
    push word [bp+4]
    call rotateleft
    pop ax

    cmp ax, bx
    jbe rac_zero

    mov ax, 1
    jmp rac_done

rac_zero:
    mov ax, 0

rac_done:
    pop bx
    pop bp
    push ax
    ret 4


start:
    mov ax, 0xFF00
    push ax
    mov ax, 8
    push ax
    call rotateandcompare
    pop ax   