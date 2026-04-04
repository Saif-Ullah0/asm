[org 0x100]
jmp start

start:
    mov ax, 0B6h
    push ax
    call remove_dups

    pop ax
    
    mov ax, 0x4C00
    int 0x21

remove_dups:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push si

    mov ax, [bp+4]
    xor bx, bx
    xor si, si
    mov cx, 16
    mov dx, ax
    shr dx, 15

bit_loop:
    shl ax, 1
    jc bit_is_1

bit_is_0:
    cmp dx, 0
    je skip_bit
    mov dx, 0
    jmp add_bit

bit_is_1:
    cmp dx, 1
    je skip_bit
    mov dx, 1

add_bit:
    rcl bx, 1
    inc si
    loop bit_loop
    jmp done_loop

skip_bit:
    loop bit_loop

done_loop:
    mov [bp+4], bx

    pop si
    pop dx
    pop cx
    pop bx
    mov sp, bp
    pop bp
    ret