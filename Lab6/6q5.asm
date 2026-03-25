[org 0x100]
jmp start

start:
    mov ax, 0xD6AE      
    mov cl, 4           
    mov dl, 11          

    ; shr by i
    shr ax, cl

    ; build mask j-i+1
    mov bl, dl
    sub bl, cl
    inc bl

    mov cl, bl
    mov bx, 1
    shl bx, cl
    dec bx

    and ax, bx
    mov bx, ax

    mov ax, 0x4c00
    int 0x21