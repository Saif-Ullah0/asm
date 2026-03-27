[org 0x100]

start:
    mov al,0ACh
    mov bl,05h
    xor dx,dx
    mov cx,8
    clc 

interleave_loop:
    shl al,1 
    rcl dx,1
    shl bl,1
    rcl dx,1
    loop interleave_loop

mov ax,dx


mov ax,0x4C00
int 0x21