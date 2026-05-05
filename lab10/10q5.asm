[org 0x0100]
jmp start

twoscomp:
    push bp
    mov bp, sp

    mov al, [bp+4]
    neg al
    mov ah, 0

    pop bp
    push ax
    ret 2

bytediff:
    push bp
    mov bp, sp
    push bx

    mov ax, [bp+6]
    mov bx, [bp+4]

    mov al, ah        ; AL = upper byte of A
    sub al, bl        ; AL = AL - lower byte of B

    jns bd_positive

    push ax           ; pass AL
    call twoscomp
    pop ax
    jmp bd_store

bd_positive:
    ; AL already correct

bd_store:
    mov ah, al        ; duplicate into both bytes

    pop bx
    pop bp
    push ax
    ret 4

start:
    mov ax, 0x5020
    push ax
    mov ax, 0x0030
    push ax
    call bytediff
    pop ax            ; AX = 2020

    mov ax, 0x4C00
    int 0x21