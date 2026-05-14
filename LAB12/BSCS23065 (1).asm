[org 0x0100]
jmp start

message: db 'Hello World!'
msglen:  dw 12
col:     dw 0

start:
    mov ax, 0xB800
    mov es, ax

ticker:
    ; clear row 0
    mov di, 0
    mov cx, 80
    mov ah, 0x07
    mov al, 0x20
clearrow:
    mov [es:di], ax
    add di, 2
    loop clearrow

    ; calculate chars to print
    mov ax, 80
    sub ax, [col]
    mov bx, [msglen]
    cmp ax, bx
    jge usefull
    mov cx, ax
    jmp startprint
usefull:
    mov cx, bx

startprint:
    mov ax, [col]
    shl ax, 1
    mov di, ax
    mov si, message
    mov ah, 0x07

printloop:
    cmp cx, 0
    je delay
    mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    dec cx
    jmp printloop

delay:
    mov cx, 0x00FF      ; reduced delay
outer:
    mov bx, 0x00FF
inner:
    dec bx
    jnz inner
    loop outer

    inc word [col]
    mov ax, [col]
    cmp ax, 80
    jl ticker
    mov word [col], 0
    jmp ticker