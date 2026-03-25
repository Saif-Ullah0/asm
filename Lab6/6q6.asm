;Write a program to swap every pair of bits in the AX register

[org 0x100]
jmp start

start:
mov ax, 0X1234
mov bx, ax
and ax, 0xAAAA
shr ax, 1

and bx, 0x5555
shl bx, 1
or ax, bx
mov ax, 0x4c00
int 0x21
