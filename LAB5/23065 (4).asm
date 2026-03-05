[org 0x0100]
jmp start

seed:   dw 0
result: dw 0

start:
    mov ax, [seed]
    mov [result], ax

    mov bx, ax
    and bx, 0x4000
    shr bx, 14

    mov dx, ax
    and dx, 0x8000
    shr dx, 15

    xor bx, dx

    and ax, 0xFFFE
    or  ax, bx

    mov [result], ax

    mov ax, 0x4C00
    int 0x21
