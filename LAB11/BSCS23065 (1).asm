[org 0x0100]
jmp start

line1: db 'Hello, this is me saif '
line2: db 'Assembly language by bao g '
line3: db 'We are writing '
line4: db 'Each char is two bytes on screen'
line5: db 'Attribute byte controls the color of ch'
line6: db 'VGA base address is 0xB800'

len1: dw 24
len2: dw 25
len3: dw 31
len4: dw 32
len5: dw 34
len6: dw 26

clearscreen:
    push es
    push ax
    push cx
    push di
    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov cx, 2000
clrloop:
    mov word [es:di], 0x0720
    add di, 2
    loop clrloop
    pop di
    pop cx
    pop ax
    pop es
    ret

printstr:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    mov ax, 0xB800
    mov es, ax
    mov di, [bp+10]
    mov si, [bp+6]
    mov cx, [bp+4]
    mov ah, [bp+8]
nextchar:
    mov al, [si]
    mov [es:di], ax
    add di, 2
    add si, 1
    loop nextchar
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 8

start:
    call clearscreen

    mov ax, 164
    push ax
    mov ax, 0x0B
    push ax
    mov ax, line1
    push ax
    push word [len1]
    call printstr

    mov ax, 484
    push ax
    mov ax, 0x0A
    push ax
    mov ax, line2
    push ax
    push word [len2]
    call printstr

    mov ax, 804
    push ax
    mov ax, 0x0E
    push ax
    mov ax, line3
    push ax
    push word [len3]
    call printstr

    mov ax, 1124
    push ax
    mov ax, 0x0C
    push ax
    mov ax, line4
    push ax
    push word [len4]
    call printstr

    mov ax, 1444
    push ax
    mov ax, 0x0D
    push ax
    mov ax, line5
    push ax
    push word [len5]
    call printstr

    mov ax, 1764
    push ax
    mov ax, 0x0F
    push ax
    mov ax, line6
    push ax
    push word [len6]
    call printstr

    mov ax, 0x4C00
    int 0x21