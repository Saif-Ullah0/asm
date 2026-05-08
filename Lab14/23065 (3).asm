[org 0x100]

start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    xor di, di          ; start from top left
    cld

nextkey:
    mov ah, 0x00
    int 0x16            ; wait for keypress, ASCII in AL
    cmp al, 0x0D        ; Enter pressed?
    je done
    mov ah, 0x07        ; white on black attribute
    stosw               ; print character to screen
    jmp nextkey

done:
    mov ax, 0x4c00
    int 0x21