[org 0x100]

start:
    mov dx, 1234h  
    mov ax, 5678h 
    shl ax, 1
    rcl dx, 1

mov ax, 0x4C00
int 0x21
