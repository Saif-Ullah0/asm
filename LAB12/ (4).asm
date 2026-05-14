[org 0x0100]
jmp start

msg1: db 'This is a line'
msg2: db 'This is another line'
len1: dw 14
len2: dw 20

start:
    mov ax, 0xB800
    mov es, ax

    ; print msg1 at row 1
    mov di, 160
    mov si, msg1
    mov cx, [len1]
    mov ah, 0x07
p1: mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    loop p1

    ; print msg2 at row 3
    mov di, 480
    mov si, msg2
    mov cx, [len2]
    mov ah, 0x07
p2: mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    loop p2

    mov ax, 0x4C00
    int 0x21