[org 0x0100]

start:
    mov ax, 0xB800
    mov es, ax
    mov di, 0           
    mov cx, 2000       
    mov bx, 0          

countloop:
    mov al, [es:di]     ; read ASCII byte
    cmp al, 0x20        ; is it a space?
    jne notspace
    inc bx          
notspace:
    add di, 2
    loop countloop     

    mov di, 3840        ; bottom-left position
    mov ax, bx          ; number to convert
    mov bx, 16          ; base 16
    mov cx, 0           ; digit counter

nextdigit:
    mov dx, 0           ; clear DX before division
    div bx              ; AX=quotient, DX=remainder
    cmp dl, 9           ; is remainder <= 9?
    jle isnum
    add dl, 0x37        ; A-F
    jmp push_digit
isnum:
    add dl, 0x30        ; 0-9
push_digit:
    push dx
    inc cx
    cmp ax, 0
    jnz nextdigit

printloop:
    pop dx
    mov dh, 0x07        ; white on black attr
    mov [es:di], dx     ; print digit
    add di, 2
    loop printloop

    mov ax, 0x4C00
    int 0x21