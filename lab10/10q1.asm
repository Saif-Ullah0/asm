[org 0x0100]
jmp start

power:
    push bp
    mov bp, sp
    push bx
    push cx

    mov bx, [bp+6]
    mov cx, [bp+4]
    mov ax, 1

    cmp cx, 0
    je pw_done

pw_loop:
    mul bx
    loop pw_loop

pw_done:
    pop cx
    pop bx
    pop bp
    push ax
    ret 4

geosum:
    push bp
    mov bp, sp
    sub sp, 4

    push bx
    push cx
    push dx

    mov cx, [bp+4]
    mov word [bp-2], 0
    mov word [bp-4], 0

gs_loop:
    cmp cx, 0
    je gs_done

    mov bx, [bp+6]
    push bx
    push word [bp-2]
    call power
    pop ax

    mov bx, [bp+8]
    mul bx
    add [bp-4], ax

    inc word [bp-2]
    dec cx
    jmp gs_loop

gs_done:
    mov ax, [bp-4]
    pop dx
    pop cx
    pop bx
    mov sp, bp
    pop bp
    push ax
    ret 6

start:
    mov ax, 2
    push ax
    mov ax, 3
    push ax
    mov ax, 4
    push ax
    call geosum
    pop ax

    mov ax, 0x4c00
    int 0x21