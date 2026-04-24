[org 0x0100]
jmp start

row:  dw 0      ; current row of top-left corner
col:  dw 0      ; current col of top-left corner
dir:  dw 1      ; 1=inward, 0xFFFF=-1=outward

start:
    mov ax, 0xB800
    mov es, ax

mainloop:
    ; check keypress to exit
    mov ah, 0x01
    int 0x16
    jz nodone
    mov ax, 0x4C00
    int 0x21
nodone:

    ; erase all 4 old positions
    call erase

    ; update position
    mov ax, [dir]
    cmp ax, 1
    je movein

    ; moving outward
    dec word [row]
    dec word [col]
    jmp checkbounds

movein:
    inc word [row]
    inc word [col]

checkbounds:
    ; check if reached center (12,12)
    mov ax, [row]
    cmp ax, 12
    je reverse
    ; check if reached corners (0,0)
    cmp ax, 0
    je reverse
    jmp draw

reverse:
    neg word [dir]

draw:
    call drawall

    ; delay
    mov cx, 0x00FF
outer:
    mov bx, 0x00FF
inner:
    dec bx
    jnz inner
    loop outer

    jmp mainloop

; draws asterisk at all 4 corner positions

drawall:
    push ax
    push bx
    push di

    mov ah, 0x0E        ; yellow attribute
    mov al, '*'

    ; top-left: (row, col)
    mov ax, [row]
    mov bx, 80
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov [es:di], ax

    ; top-right: (row, 24-col)
    mov ax, [row]
    mul bx
    mov di, ax
    mov ax, 24
    sub ax, [col]
    add di, ax
    shl di, 1
    mov word [es:di], 0x0E2A

    ; bottom-left: (24-row, col)
    mov ax, 24
    sub ax, [row]
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0E2A

    ; bottom-right: (24-row, 24-col)
    mov ax, 24
    sub ax, [row]
    mul bx
    mov di, ax
    mov ax, 24
    sub ax, [col]
    add di, ax
    shl di, 1
    mov word [es:di], 0x0E2A

    pop di
    pop bx
    pop ax
    ret

; erases asterisk at all 4 corner positions

erase:
    push ax
    push bx
    push di

    ; top-left
    mov ax, [row]
    mov bx, 80
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0720

    ; top-right
    mov ax, [row]
    mul bx
    mov di, ax
    mov ax, 24
    sub ax, [col]
    add di, ax
    shl di, 1
    mov word [es:di], 0x0720

    ; bottom-left
    mov ax, 24
    sub ax, [row]
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0720

    ; bottom-right
    mov ax, 24
    sub ax, [row]
    mul bx
    mov di, ax
    mov ax, 24
    sub ax, [col]
    add di, ax
    shl di, 1
    mov word [es:di], 0x0720

    pop di
    pop bx
    pop ax
    ret