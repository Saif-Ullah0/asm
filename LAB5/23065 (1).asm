[org 0x0100]
jmp start

arr:  db 1,3,5,7,9,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
size: dw 20
sum:  dw 0

start:
    mov bx, arr
    mov cx, [size]

loopS:
    mov ax, bx
    mov dx, 0
    mov di, 3
    div di
    cmp dx, 0
    jne skip

    mov al, [bx]
    mov ah, 0
    add [sum], ax

skip:
    inc bx
    loop loopS

    mov ax, 0x4C00
    int 0x21