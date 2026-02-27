[org 0x100]

mov si, arr
mov al, [si]
mov bl, [si]
mov cx, 9
add si, 1

loops:
mov dl, [si]
cmp dl,al
jle nmax
mov al,dl

nmax:
cmp dl, bl
jge nmin
mov bl,dl

nmin:
add si,1
loop loops

mov [max],al
mov [min],bl

mov ax, 0x4c00
int 0x21

arr: db 7, 2, 3, 4, 1, 5, 6, 9, 8, 0
max :db 0
min : db 0

