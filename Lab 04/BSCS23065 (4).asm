[org 0x0100]
jmp start

array:      dw 1,3,2,1,1,2,5,7,2,4,5,6,7,6
size:       dw 14
duplicates: times 14 dw 0
dup_size:   dw 0
distincts:  times 14 dw 0
dist_size:  dw 0

start:
    mov cx, [size]
    shl cx, 1
    mov si, 0

outer_loop:
    mov ax, [array+si]
    mov bx, 0
    mov dx, 0

count_loop:
    mov di, [array+bx]
    cmp di, ax
    jne skip
    inc dx
skip:
    add bx, 2
    cmp bx, cx
    jl count_loop

    push si
    push cx

    ; check distincts
    mov di, 0
    mov cx, [dist_size]
    shl cx, 1

chk_dist:
    cmp cx, 0
    je add_dist
    mov bx, [distincts+di]
    cmp bx, ax
    je done_dist
    add di, 2
    sub cx, 2
    jmp chk_dist

add_dist:
    mov di, [dist_size]
    shl di, 1
    mov [distincts+di], ax
    inc word [dist_size]

done_dist:
    ; check duplicates
    cmp dx, 1
    jle skip_dup

    mov di, 0
    mov cx, [dup_size]
    shl cx, 1

chk_dup:
    cmp cx, 0
    je add_dup
    mov bx, [duplicates+di]
    cmp bx, ax
    je done_dup
    add di, 2
    sub cx, 2
    jmp chk_dup

add_dup:
    mov di, [dup_size]
    shl di, 1
    mov [duplicates+di], ax
    inc word [dup_size]

done_dup:
skip_dup:
    pop cx
    pop si
    add si, 2
    cmp si, cx
    jl outer_loop

mov ax, 0x4C00
int 0x21