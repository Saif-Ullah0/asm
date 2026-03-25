;Write a program to swap first 4 bits with the last 4 bits in AX.
[org 0x100]
jmp start

start:
mov ax, 0x1234
mov bx,ax
and ax,0x000F
shl ax,12
and bx,0xF000
shr bx,12
or ax,bx

mov ax, 0x4c00
int 0x21
