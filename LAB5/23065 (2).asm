[org 0x0100]
jmp start

arr:  db 1,3,5,7,9,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
size: dw 20
sum:  dw 0

start:
    mov bx, arr
    mov cx, [size]

sum_loop:
    mov al, [bx]
    mov ah, 0
    add [sum], ax
    inc bx
    loop sum_loop

    mov ax, [sum]
    and ax, 0x000F       
    mov bx, ax         

    mov cx, bx           
    mov dx, 1
    shl dx, cl           
    xor bx, dx           

    mov ax, 0x4C00
    int 0x21