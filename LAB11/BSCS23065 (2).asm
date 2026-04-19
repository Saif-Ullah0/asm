[org 0x0100]

start:
    mov ax, 0xB800
    mov es, ax
    mov di, 0           
    mov bx, 0           

scanloop:
    mov al, [es:di]     ; read ASCII byte

    cmp al, 0x20
    je isspace
    mov bx, 0           ; reset counter
    jmp changecolor

isspace:
    inc bx
    cmp bx, 3          ; 3 continuous spaces = end of text
    je done

changecolor:
    mov byte [es:di+1], 0x0E    ; overwrite attribute byte only
    add di, 2
    jmp scanloop

done:
    mov ax, 0x4C00
    int 0x21