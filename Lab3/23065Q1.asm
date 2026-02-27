
[org 0x0100]


mov al, [n1]
add al, [n2]
add al, 7

mov [ans], al
mov [wans], ax
mov ax,0x4c00
int 0x21


n1 : db 5
n2 : db 8 
ans : db 0
wans : dw 0