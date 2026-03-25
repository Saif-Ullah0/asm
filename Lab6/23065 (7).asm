;Write a program to swap the nibbles in each byte of the AX register.

[org 0x100]
jmp start

start:
mov ax, 0x1234
mov bx, ax
and ax, 0xF0F0
shl ax, 4
and bx, 0x0F0F
shr bx, 4
or ax, bx
mov ax, 0x4c00
int 0x21