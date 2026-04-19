[org 0x0100]
jmp start

length: dw 5
i:      dw 0
row:    dw 0

start:
    mov ax, 0xB800
    mov es, ax
    mov word [i], 0
    mov word [row], 0

toploop:
    mov ax, [i]
    cmp ax, [length]
    je bottom

    mov ax, [row]
    mov bx, 160
    mul bx
    mov di, ax

    mov cx, [length]
    sub cx, 1
    sub cx, [i]
    mov ah, 0x07
    mov al, 0x20
topspace:
    cmp cx, 0
    je topstar
    mov [es:di], ax
    add di, 2
    dec cx
    jmp topspace

topstar:
    mov cx, [i]
    shl cx, 1
    inc cx
    mov al, '*'
topstarloop:
    cmp cx, 0
    je topdone
    mov [es:di], ax
    add di, 2
    dec cx
    jmp topstarloop

topdone:
    inc word [i]
    inc word [row]
    jmp toploop

bottom:
    mov ax, [length]
    sub ax, 2
    mov [i], ax

botloop:
    mov ax, [i]
    cmp ax, 0
    jl done

    mov ax, [row]
    mov bx, 160
    mul bx
    mov di, ax

    mov cx, [length]
    sub cx, 1
    sub cx, [i]
    mov ah, 0x07
    mov al, 0x20
botspace:
    cmp cx, 0
    je botstar
    mov [es:di], ax
    add di, 2
    dec cx
    jmp botspace

botstar:
    mov cx, [i]
    shl cx, 1
    inc cx
    mov al, '*'
botstarloop:
    cmp cx, 0
    je botdone
    mov [es:di], ax
    add di, 2
    dec cx
    jmp botstarloop

botdone:
    dec word [i]
    inc word [row]
    jmp botloop

done:
    mov ax, 0x4C00
    int 0x21