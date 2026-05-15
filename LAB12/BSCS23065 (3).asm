[org 0x0100]
jmp start

needle:    db 'line'      ; string to search for
nlen:      dw 4           ; length of search string

start:
    mov ax, 0xB800
    mov es, ax
    mov di, 0             ; current screen position (byte offset)
    mov cx, 2000          ; total screen characters

scanloop:
    ; compare needle with screen at current position
    push cx
    push di

    mov si, needle
    mov cx, [nlen]
    mov bx, di            ; save start of match position

matchloop:
    mov al, [es:bx]       ; read ASCII from screen
    mov dl, [si]          ; read char from needle
    cmp al, dl
    jne nomatch           ; mismatch, stop comparing
    add bx, 2             ; next screen char
    add si, 1             ; next needle char
    loop matchloop

    ; full match found — highlight
    pop di                ; restore start position
    push di
    mov cx, [nlen]
    mov bx, di
highlightloop:
    mov byte [es:bx+1], 0x4E  ; red background yellow text
    add bx, 2
    loop highlightloop

nomatch:
    pop di
    pop cx
    add di, 2             ; move to next screen position
    loop scanloop

    mov ax, 0x4C00
    int 0x21