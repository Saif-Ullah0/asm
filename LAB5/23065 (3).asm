[org 0x0100]
jmp start

num1:   dw 46080
num2:   dw 31713
count0: dw 0
count1: dw 0

start:
    mov ax, [num1]
    mov cx, 16

loop0:
    shr ax, 1
    jc skip0
    inc word [count0]
skip0:
    loop loop0

    mov ax, [num2]
    mov cx, 16

loop1:
    shr ax, 1
    jnc skip1
    inc word [count1]
skip1:
    loop loop1

    mov ax, 0x4C00
    int 0x21
