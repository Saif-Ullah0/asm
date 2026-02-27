[org 0x0100]
jmp start

array:    dw 2,10,12,8,18,13,26,5
size:     dw 8
mid_pos1: dw 0
mid_pos2: dw 0
element1: dw 0
element2: dw 0
median:   dw 0

start:
    mov ax, [size]
    shr ax, 1
    mov [mid_pos1], ax
    inc ax
    mov [mid_pos2], ax

    mov cx, [size]
    shl cx, 1
    mov si, 0

outer_loop:
    mov ax, [array+si]
    mov bx, 0
    mov dx, 0

inner_loop:
    cmp bx, si
    je skip_self
    mov di, [array+bx]
    cmp di, ax
    jge skip_count
    inc dx

skip_count:
skip_self:
    add bx, 2
    cmp bx, cx
    jl inner_loop

    inc dx

    cmp dx, [mid_pos1]
    jne chk_pos2
    mov [element1], ax

chk_pos2:
    cmp dx, [mid_pos2]
    jne next_elem
    mov [element2], ax

next_elem:
    add si, 2
    cmp si, cx
    jl outer_loop

    mov ax, [element1]
    add ax, [element2]
    shr ax, 1
    mov [median], ax

mov ax, 0x4C00
int 0x21