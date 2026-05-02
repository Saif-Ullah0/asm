[org 0x0100]
jmp start

row:    dw 0
col:    dw 0
phase:  dw 0        ; 0=top 1=right 2=bottom 3=left

start:
    mov ax, 0xB800
    mov es, ax

    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw

mainloop:
    ; check keypress
    mov ah, 0x01
    int 0x16
    jz nokey
    mov ax, 0x4C00
    int 0x21
nokey:

    ; erase old position
    mov ax, [row]
    mov bx, 80
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0720

    ; update position based on phase
    mov ax, [phase]
    cmp ax, 0
    je dotop
    cmp ax, 1
    je doright
    cmp ax, 2
    je dobottom
    jmp doleft

dotop:
    inc word [col]
    mov ax, [col]
    cmp ax, 79
    jl draw
    mov word [phase], 1
    jmp draw

doright:
    inc word [row]
    mov ax, [row]
    cmp ax, 24
    jl draw
    mov word [phase], 2
    jmp draw

dobottom:
    dec word [col]
    mov ax, [col]
    cmp ax, 0
    jg draw
    mov word [phase], 3
    jmp draw

doleft:
    dec word [row]
    mov ax, [row]
    cmp ax, 0
    jg draw
    mov word [phase], 0
    jmp draw

draw:
    ; draw asterisk at new position
    mov ax, [row]
    mov bx, 80
    mul bx
    add ax, [col]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0B2A

    ; delay
    mov cx, 0x00FF
outer:
    mov bx, 0x00FF
inner:
    dec bx
    jnz inner
    loop outer

    jmp mainloop