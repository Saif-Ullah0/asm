[org 0x0100]

jmp start

chardata: db 'H', 0x0B, 'e', 0x0C, 'l', 0x0D, 'l', 0x0E, 'o', 0x0F
          db ' ', 0x07, 'S', 0x0A, 'a', 0x0B, 'i', 0x0C, 'f', 0x0D
          db 'i', 0x0E, '!', 0x0F
charcount: dw 12

; subroutine: printcolor
; receives via stack: address of chardata, count
; [bp+4] = count
; [bp+6] = address of chardata
printcolor:
    push bp
    mov bp, sp
    push si
    push di
    push ds
    push es

    mov ax, cs
    mov ds, ax
    mov ax, [bp+6]
    mov si, ax
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov cx, [bp+4]

nextchar:
    lodsb
    mov ah, [si]
    inc si
    stosw
    loop nextchar

    pop es
    pop ds
    pop di
    pop si
    pop bp
    ret 4

start:
    mov ax, cs
    mov ds, ax

    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw

    push word chardata
    push word [charcount]
    call printcolor

    mov ax, 0x4C00
    int 0x21
