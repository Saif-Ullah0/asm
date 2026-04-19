[org 0x0100]
jmp start

line1: db 'enil rehto na si siht'
line2: db 'enil a si siht'

len1: dw 21
len2: dw 14

start:
    mov ax, 0xB800
    mov es, ax

    mov di, 0
    mov si, line1
    mov cx, [len1]
    mov ah, 0x07
l1: mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    loop l1

    mov di, 160
    mov si, line2
    mov cx, [len2]
    mov ah, 0x07
l2: mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    loop l2

    mov ax, 0x4C00
    int 0x21