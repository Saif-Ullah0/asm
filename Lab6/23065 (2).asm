[org 0x100]

jmp start

start:
mov ax, 0x1234
mov cx, 16
mov bx,0
mov dx,0 

loop1:
shl ax,1
jnc reset

inc dx
cmp dx,bx
jle skip
mov bx,dx
jmp skip

reset:
mov dx,0

skip:
loop loop1

mov ax, 0x4c00
int 0x21