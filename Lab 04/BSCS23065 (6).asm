[org 0x0100]
jmp start

array:        dw 1,3,2,1,1,2,5,7,2,4,5,6,7,6
size:         dw 14
unique:       times 14 dw 0
freq:         times 14 dw 0
unique_count: dw 0
result:       times 14 dw 0
swap_flag:    db 0

start:
    mov cx, [size]
    shl cx, 1
    mov si, 0

find_unique:
    mov ax, [array+si]
    push si
    push cx
    mov di, 0
    mov cx, [unique_count]
    shl cx, 1

chk_unique:
    cmp cx, 0
    je add_unique
    mov bx, [unique+di]
    cmp bx, ax
    je found_unique
    add di, 2
    sub cx, 2
    jmp chk_unique

add_unique:
    mov bx, [unique_count]
    shl bx, 1
    mov [unique+bx], ax
    mov word [freq+bx], 0
    inc word [unique_count]

found_unique:
    pop cx
    pop si
    add si, 2
    cmp si, cx
    jl find_unique

    mov si, 0
    mov cx, [size]
    shl cx, 1

count_freq:
    mov ax, [array+si]
    mov di, 0
    mov bx, [unique_count]
    shl bx, 1

find_in_unique:
    mov dx, [unique+di]
    cmp dx, ax
    je inc_freq
    add di, 2
    sub bx, 2
    jnz find_in_unique

inc_freq:
    inc word [freq+di]
    add si, 2
    cmp si, cx
    jl count_freq

    mov cx, [unique_count]
    dec cx

sort_freq:
    mov si, 0
    mov byte [swap_flag], 0

inner_sort:
    mov bx, si
    shl bx, 1
    mov ax, [freq+bx]
    mov dx, [freq+bx+2]
    cmp ax, dx
    jge no_swap

    mov [freq+bx], dx
    mov [freq+bx+2], ax
    mov ax, [unique+bx]
    mov dx, [unique+bx+2]
    mov [unique+bx], dx
    mov [unique+bx+2], ax
    mov byte [swap_flag], 1

no_swap:
    inc si
    cmp si, cx
    jl inner_sort
    cmp byte [swap_flag], 1
    je sort_freq

    mov di, 0
    mov si, 0
    mov cx, [unique_count]
    shl cx, 1

build_result:
    mov bx, si
    mov ax, [unique+bx]
    mov dx, [freq+bx]

fill:
    mov [result+di], ax
    add di, 2
    dec dx
    jnz fill

    add si, 2
    cmp si, cx
    jl build_result

mov ax, 0x4C00
int 0x21