[org 0x0100]
jmp start

array:     dw 2,10,12,8,18,13,26,5,19
size:      dw 9
evens:     times 9 dw 0
positions: times 9 dw 0
evencount: dw 0
swapflag:  db 0

start:
    mov cx, [size]
    shl cx, 1
    mov si, 0

extract:
    mov ax, [array+si]
    test ax, 1
    jnz skip_extract

    mov bx, [evencount]
    shl bx, 1
    mov [evens+bx], ax
    mov [positions+bx], si
    inc word [evencount]

skip_extract:
    add si, 2
    cmp si, cx
    jl extract

    mov cx, [evencount]
    dec cx

outer:
    mov si, 0
    mov byte [swapflag], 0

inner:
    mov bx, si
    shl bx, 1

    mov ax, [evens+bx]
    mov dx, [evens+bx+2]
    cmp ax, dx
    jle no_swap

    mov [evens+bx], dx
    mov [evens+bx+2], ax

    mov ax, [positions+bx]
    mov dx, [positions+bx+2]
    mov [positions+bx], dx
    mov [positions+bx+2], ax

    mov byte [swapflag], 1

no_swap:
    inc si
    cmp si, cx
    jl inner

    cmp byte [swapflag], 1
    je outer

    mov si, 0
    mov cx, [evencount]
    shl cx, 1

putback:
    mov bx, [positions+si]
    mov ax, [evens+si]
    mov [array+bx], ax
    add si, 2
    cmp si, cx
    jl putback

mov ax, 0x4C00
int 0x21