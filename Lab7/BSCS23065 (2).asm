[org 0x100]

start:
    mov ax, 0ABCDh  
    shr ax, 5
    and ax, 3Fh
    mov bl, al     

mov ax, 0x4C00
int 0x21            