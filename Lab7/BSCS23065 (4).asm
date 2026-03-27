[org 0x100]

start:
    mov ax, 1234h
    mov cl, 4
    
    rol ax, cl
    xor ax, 0A5A5h
    ror ax, 3
    
    mov dx, ax
    
    mov ax, 0x4C00
    int 0x21
