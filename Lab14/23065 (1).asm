[org 0x100]
jmp start

message: db 'Hello World This Is COAL Lab', 0

start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov si, message
    cld

nextchar:
    lodsb
    cmp al, 0
    je done
    cmp al, 65
    jl store
    cmp al, 90
    jle toupper
    cmp al, 97
    jl store
    cmp al, 122
    jg store
    sub al, 32          ; lowercase to uppercase
    jmp store

toupper:
    add al, 32          ; uppercase to lowercase

store:
    mov ah, 0x07        ; white on black attribute
    stosw
    jmp nextchar

done:
    mov ax, 0x4c00
    int 0x21