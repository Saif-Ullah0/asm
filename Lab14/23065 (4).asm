[org 0x100]
jmp start

lp: db 'LP'
lr: db 'LR'
rp: db 'RP'
rr: db 'RR'

start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    xor di, di
    cld

poll:
    in al, 0x60         ; read scancode from keyboard port

    cmp al, 0x4B        ; left arrow press
    je printlp
    cmp al, 0xCB        ; left arrow release
    je printlr
    cmp al, 0x4D        ; right arrow press
    je printrp
    cmp al, 0xCD        ; right arrow release
    je printrr
    cmp al, 0x01        ; ESC to exit
    je done
    jmp poll

printlp:
    mov si, lp
    call printstr
    jmp poll

printlr:
    mov si, lr
    call printstr
    jmp poll

printrp:
    mov si, rp
    call printstr
    jmp poll

printrr:
    mov si, rr
    call printstr
    jmp poll

; prints 2 chars from DS:SI to ES:DI
printstr:
    lodsb
    mov ah, 0x07
    stosw
    lodsb
    mov ah, 0x07
    stosw
    ret

done:
    mov ax, 0x4c00
    int 0x21