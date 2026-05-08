[org 0x100]
jmp start

message: db 'This is a paragraph written in assembly language for COAL Lab at ITU Lahore. '
         db 'We are learning string instructions including LODS and STOS. '
         db 'These instructions help us process blocks of memory efficiently. '
         db 'LODS loads a byte from DS:SI into AL and increments SI automatically. '
         db 'STOS stores AX into ES:DI which points to video memory and increments DI. '
         db 'Together they allow us to read and display characters one by one. '
         db 'This paragraph is long enough to cover more than half of the DOS screen. '
         db 'Assembly language is low level but very powerful and educational. '
         db 'We are students of Information Technology University Lahore Pakistan. '
         db 'This is the end of our paragraph for Task 2 of Lab 14 COAL course.', 0

start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    xor di, di          ; start from top left
    mov si, message
    cld

nextchar:
    lodsb
    cmp al, 0
    je done
    mov ah, 0x07        ; white on black attribute
    stosw
    jmp nextchar

done:
    mov ax, 0x4c00
    int 0x21