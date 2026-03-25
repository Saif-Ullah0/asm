[org 0x100]

jmp start

start:
mov ax, 0x123
mov bl, al
mov cl, 8

reverse:
shl bl, 1
rcl al, 1
loop reverse

mov ax, 0x4c00
int 0x21
