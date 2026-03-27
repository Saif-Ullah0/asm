[org 0x100]

start:
    mov al, 0B6h
    and al, 0Fh
    
    mov ax, 0x4C00
    int 0x21
