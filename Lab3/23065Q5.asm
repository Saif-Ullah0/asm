[org 0x100]

mov word [left], 0
mov word [right], 9

search:
mov ax, [left]
cmp ax,[right]
jg none

mov ax,[left]
add ax,[right]
shr ax,1
mov [mid], ax

mov bx,[mid]
shl bx,1
mov ax,[arr+bx]

cmp ax,[target]
je find
jl searchRight
jg searchLeft

find:
mov ax,[mid]
jmp exit

searchRight:
mov ax,[mid]
inc ax
mov [left],ax
jmp search



searchLeft:
mov ax,[mid]
dec ax
mov [right],ax
jmp search

none:
mov ax,-1
jmp exit

exit:
mov bx,ax
mov ax, 0x4c00
int 0x21

arr: dw 0, 1, 2, 5, 7, 9, 12, 15, 16, 20
target: dw 12
left: dw 0
right: dw 0
mid: dw 0