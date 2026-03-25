;Write a program to toggle only the even-positioned bits in AX.

[org 0x100]
jmp start

start:
mov ax,0x1234
xor ax,0x5555

mov ax, 0x4c00
int 0x21