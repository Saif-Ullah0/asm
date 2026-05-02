[org 0x0100]
jmp start

mystring: db 'Hello saifi This Is Assembly'
strlen:   dw 36
vowelcount: dw 0

start:
    mov ax, cs
    mov ds, ax

    mov ax, 0xB800
    mov es, ax

    ; clear screen
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw

    ; count vowels
    mov si, mystring
    mov cx, [strlen]
    mov word [vowelcount], 0

nextchar:
    lodsb               ; AL = next char, SI++
    cmp al, 'a'
    je isvowel
    cmp al, 'e'
    je isvowel
    cmp al, 'i'
    je isvowel
    cmp al, 'o'
    je isvowel
    cmp al, 'u'
    je isvowel
    cmp al, 'A'
    je isvowel
    cmp al, 'E'
    je isvowel
    cmp al, 'I'
    je isvowel
    cmp al, 'O'
    je isvowel
    cmp al, 'U'
    je isvowel
    jmp notvowel

isvowel:
    inc word [vowelcount]

notvowel:
    loop nextchar

    ; print vowel count in hex at last row (offset 3840)
    mov di, 3840
    mov ax, [vowelcount]
    mov bx, 16
    mov cx, 0

hexloop:
    mov dx, 0
    div bx
    cmp dl, 9
    jle isnum
    add dl, 0x37
    jmp pushdigit
isnum:
    add dl, 0x30
pushdigit:
    push dx
    inc cx
    cmp ax, 0
    jnz hexloop

printloop:
    pop dx
    mov dh, 0x0E
    mov [es:di], dx
    add di, 2
    loop printloop

    mov ax, 0x4C00
    int 0x21