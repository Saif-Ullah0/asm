[org 0x0100]
jmp start

array: dw 2,10,12,8,18,13,26,5,19
size:  dw 9
evenC: dw 0
oddC:  dw 0

start:
    mov cx, [size]
    shl cx, 1
    mov bx, 0

count_loop:
    mov ax, [array+bx]
    test ax, 1
    jz isEven

isOdd:
    inc word [oddC]
    jmp next

isEven:
    inc word [evenC]

next:
    add bx, 2
    cmp bx, cx
    jl count_loop

mov ax, 0x4C00
int 0x21