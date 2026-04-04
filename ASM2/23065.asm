org 0x100
jmp start

num1: dw 100, 200, 300, 400, 500, 600, 700, 800
      dw 101, 201, 301, 401, 501, 601, 701, 801
      dw 102, 202, 302, 402, 502, 602, 702, 802
      dw 103, 203, 303, 403, 503, 603, 703, 803

num2: dw 10, 20, 30, 40, 50, 60, 70, 80
      dw 11, 21, 31, 41, 51, 61, 71, 81
      dw 12, 22, 32, 42, 52, 62, 72, 82
      dw 13, 23, 33, 43, 53, 63, 73, 83

result: times 32 dw 0

start:
    mov si, num1
    mov di, num2
    mov bx, result
    mov cx, 32
    clc

add_loop:
    mov ax, [si]
    adc ax, [di]
    mov [bx], ax
    add si, 2
    add di, 2
    add bx, 2

    loop add_loop

    mov ax, 0x4C00
    int 0x21