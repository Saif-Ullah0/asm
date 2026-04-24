[org 0x0100]
jmp start

src_top:  dw 1
src_bot:  dw 3
dst_top:  dw 0

start:
    mov ax, 0xB800
    mov es, ax

    ; height = src_bot - src_top + 1 = 3
    mov ax, [src_bot]
    sub ax, [src_top]
    inc ax
    mov bx, ax              ; BX = 3

    ; dst_top = (25 - 3) / 2 = 11
    mov ax, 25
    sub ax, bx
    shr ax, 1
    mov [dst_top], ax       ; dst_top = 11

    ; step 1 - save source into buffer
    mov ax, [src_top]
    mov cx, 160
    mul cx
    mov si, ax              ; SI = row 1 offset = 160

    mov di, buffer
    mov ax, bx
    mov cx, 80
    mul cx
    mov cx, ax              ; CX = 3*80 = 240 words

saveloop:
    mov ax, [es:si]
    mov [di], ax
    add si, 2
    add di, 2
    loop saveloop

    ; step 2 - clear screen
    mov di, 0
    mov cx, 2000
    mov ah, 0x07
    mov al, 0x20
clrloop:
    mov [es:di], ax
    add di, 2
    loop clrloop

    ; step 3 - write buffer to center (row 11)
    mov ax, [dst_top]
    mov cx, 160
    mul cx
    mov di, ax              ; DI = row 11 offset = 1760

    mov si, buffer
    mov cx, 240             ; 3 rows * 80 chars

writeloop:
    mov ax, [si]
    mov [es:di], ax
    add si, 2
    add di, 2
    loop writeloop

    mov ax, 0x4C00
    int 0x21

buffer: times 480 db 0