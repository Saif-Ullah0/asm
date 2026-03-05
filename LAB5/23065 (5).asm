[org 0x0100]
jmp start

num:    dw 0x0039
result: dw 0

start:
    mov ax, [num]
    mov bx, ax
    mov dx, 0
    mov cx, 16

reverse_loop:
    shr bx, 1
    rcl dx, 1
    loop reverse_loop

    cmp ax, dx
    je is_palindrome

not_palindrome:
    mov ax, 0
    jmp exit

is_palindrome:
    mov ax, 1

exit:
    mov [result], ax
    mov ax, 0x4C00
    int 0x21
