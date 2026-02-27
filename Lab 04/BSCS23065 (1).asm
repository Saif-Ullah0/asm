[org 0x0100]
jmp start

array: dw 2,10,12,8,18,13,26,5,19
size:  dw 9
max:   dw 0
smax:  dw 0
min:   dw 0xFFFF
smin:  dw 0xFFFF

start:
    mov ax, [array]
    mov [max], ax
    mov [min], ax

    mov cx, [size]
    shl cx, 1
    mov bx, 0

max_loop:
    mov ax, [array+bx]
    cmp ax, [max]
    jle chk_smax
    mov dx, [max]
    mov [smax], dx
    mov [max], ax
    jmp next

chk_smax:
    cmp ax, [smax]
    jle next
    cmp ax, [max]
    je next
    mov [smax], ax

next:
    add bx, 2
    cmp bx, cx
    jl max_loop

    mov bx, 0

min_loop:
    mov ax, [array+bx]
    cmp ax, [min]
    jge chk_smin
    mov dx, [min]
    mov [smin], dx
    mov [min], ax
    jmp next2

chk_smin:
    cmp ax, [smin]
    jge next2
    cmp ax, [min]
    je next2
    mov [smin], ax

next2:
    add bx, 2
    cmp bx, cx
    jl min_loop

mov ax, 0x4C00
int 0x21