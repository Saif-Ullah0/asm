[org 0x0100]
jmp start

; asterisk 1
r1:     dw 0
c1:     dw 0
rd1:    dw 1        ; row dir down
cd1:    dw 1        ; col dir right

; asterisk 2
r2:     dw 0
c2:     dw 79
rd2:    dw 1        ; row dir down
cd2:    dw 0xFFFF   ; col dir left (-1)

start:
    mov ax, 0xB800
    mov es, ax

    ; clear screen
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw

mainloop:
    ; check keypress to exit
    mov ah, 0x01
    int 0x16
    jz nodone
    mov ax, 0x4C00
    int 0x21
nodone:

    ; erase asterisk 1
    mov ax, [r1]
    mov bx, 80
    mul bx
    add ax, [c1]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0720

    ; erase asterisk 2
    mov ax, [r2]
    mov bx, 80
    mul bx
    add ax, [c2]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0720

    ; update asterisk 1 position
    mov ax, [r1]
    add ax, [rd1]
    mov [r1], ax
    mov ax, [c1]
    add ax, [cd1]
    mov [c1], ax

    ; bounce asterisk 1
    mov ax, [r1]
    cmp ax, 24
    jl chkr1top
    mov word [rd1], 0xFFFF
chkr1top:
    cmp ax, 0
    jg chkc1right
    mov word [rd1], 1
chkc1right:
    mov ax, [c1]
    cmp ax, 79
    jl chkc1left
    mov word [cd1], 0xFFFF
chkc1left:
    cmp ax, 0
    jg ast2update
    mov word [cd1], 1

    ; update asterisk 2 position
ast2update:
    mov ax, [r2]
    add ax, [rd2]
    mov [r2], ax
    mov ax, [c2]
    add ax, [cd2]
    mov [c2], ax

    ; bounce asterisk 2
    mov ax, [r2]
    cmp ax, 24
    jl chkr2top
    mov word [rd2], 0xFFFF
chkr2top:
    cmp ax, 0
    jg chkc2right
    mov word [rd2], 1
chkc2right:
    mov ax, [c2]
    cmp ax, 79
    jl chkc2left
    mov word [cd2], 0xFFFF
chkc2left:
    cmp ax, 0
    jg drawboth
    mov word [cd2], 1

drawboth:
    ; draw asterisk 1
    mov ax, [r1]
    mov bx, 80
    mul bx
    add ax, [c1]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0E2A

    ; draw asterisk 2
    mov ax, [r2]
    mov bx, 80
    mul bx
    add ax, [c2]
    shl ax, 1
    mov di, ax
    mov word [es:di], 0x0C2A

    ; delay
    mov cx, 0x00FF
outer:
    mov bx, 0x00FF
inner:
    dec bx
    jnz inner
    loop outer

    jmp mainloop