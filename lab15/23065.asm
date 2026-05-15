[org 0x100]
jmp start

board:      db 0,0,0,0,0,0,0,0,0    ; 0=empty 1=p1 2=p2
p1queue:    db 0xFF,0xFF,0xFF        ; LRU queue player1
p2queue:    db 0xFF,0xFF,0xFF        ; LRU queue player2
p1count:    db 0
p2count:    db 0
turn:       db 1                     ; 1=player1 2=player2
cellpos:    dw 322,330,338,642,650,658,962,970,978
row2:       db '   |   |   ',0
sep:        db '---+---+---',0
msgp1win:   db 'Player 1 Wins!', 0
msgp2win:   db 'Player 2 Wins!', 0
msgdraw:    db 'Draw!', 0
wins:       db 0,1,2, 3,4,5, 6,7,8
            db 0,3,6, 1,4,7, 2,5,8
            db 0,4,8, 2,4,6

start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax
    cld
    call drawboard

gameloop:
    ; get keypress
    mov ah, 0x00
    int 0x16
    sub al, '0'         ; ASCII to number
    cmp al, 1
    jl gameloop
    cmp al, 9
    jg gameloop

    mov bl, al
    dec bl              ; 0-based index
    mov bh, 0

    ; check if occupied
    mov al, [board + bx]
    cmp al, 0
    jne gameloop

    ; save cell index in DL
    mov dl, bl

    mov al, [turn]
    cmp al, 1
    je p1move

p2move:
    mov al, [p2count]
    cmp al, 3
    jl p2place
    ; remove oldest p2 mark
    xor bh, bh
    mov bl, [p2queue]
    mov byte [board + bx], 0
    mov al, [p2queue+1]
    mov [p2queue], al
    mov al, [p2queue+2]
    mov [p2queue+1], al
p2place:
    xor bh, bh
    mov bl, dl
    mov byte [board + bx], 2
    mov al, [p2count]
    cmp al, 3
    jge p2qfull
    xor bh, bh
    mov bl, al
    mov [p2queue + bx], dl
    inc byte [p2count]
    jmp afterplace
p2qfull:
    mov [p2queue+2], dl
    jmp afterplace

p1move:
    mov al, [p1count]
    cmp al, 3
    jl p1place
    ; remove oldest p1 mark
    xor bh, bh
    mov bl, [p1queue]
    mov byte [board + bx], 0
    mov al, [p1queue+1]
    mov [p1queue], al
    mov al, [p1queue+2]
    mov [p1queue+1], al
p1place:
    xor bh, bh
    mov bl, dl
    mov byte [board + bx], 1
    mov al, [p1count]
    cmp al, 3
    jge p1qfull
    xor bh, bh
    mov bl, al
    mov [p1queue + bx], dl
    inc byte [p1count]
    jmp afterplace
p1qfull:
    mov [p1queue+2], dl

afterplace:
    call drawboard
    call checkwinner    ; exits if winner found

    ; check draw: all 9 cells filled
    mov cx, 9
    mov bx, 0
checkdraw:
    mov al, [board + bx]
    cmp al, 0
    je nodraw
    inc bx
    loop checkdraw
    ; draw condition
    mov di, 1280
    mov si, msgdraw
    call printrow
    mov ah, 0x00
    int 0x16
    mov ax, 0x4c00
    int 0x21
nodraw:
    ; switch turn
    mov al, [turn]
    cmp al, 1
    je tog2
    mov byte [turn], 1
    jmp gameloop
tog2:
    mov byte [turn], 2
    jmp gameloop

drawboard:
    push ax
    push cx
    push si
    push di
    call clrscr

    ; show whose turn at row 0
    mov di, 0
    mov al, [turn]
    add al, '0'         ; convert to ASCII
    mov ah, 0x0A        ; green
    stosw

    mov di, 320
    mov si, row2
    call printrow
    mov di, 480
    mov si, sep
    call printrow
    mov di, 640
    mov si, row2
    call printrow
    mov di, 800
    mov si, sep
    call printrow
    mov di, 960
    mov si, row2
    call printrow

    call drawmarks
    pop di
    pop cx
    pop si
    pop ax
    ret

printrow:
    lodsb
    cmp al, 0
    je printrowdone
    mov ah, 0x07
    stosw
    jmp printrow
printrowdone:
    ret

clrscr:
    push ax
    push cx
    push di
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw
    pop di
    pop cx
    pop ax
    ret

drawmarks:
    push ax
    push bx
    push cx
    push si
    push di
    mov cx, 9
    mov bx, 0
nextcell:
    mov al, [board + bx]
    mov si, bx
    shl si, 1
    mov di, [cellpos + si]
    cmp al, 1
    je drawx
    cmp al, 2
    je drawo
    jmp celldone
drawx:
    mov ax, 0x0C58      ; red X
    mov [es:di], ax
    jmp celldone
drawo:
    mov ax, 0x0B4F      ; cyan O
    mov [es:di], ax
celldone:
    inc bx
    loop nextcell
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret

checkwinner:
    push ax
    push bx
    push cx
    push si
    mov si, wins
    mov cx, 8
checkloop:
    xor bh, bh
    mov bl, [si]
    mov al, [board+bx]
    cmp al, 0
    je nextline
    mov dl, al
    mov bl, [si+1]
    mov al, [board+bx]
    cmp al, dl
    jne nextline
    mov bl, [si+2]
    mov al, [board+bx]
    cmp al, dl
    jne nextline
    ; winner found in DL
    call drawboard
    mov di, 1280
    cmp dl, 1
    je winp1
    mov si, msgp2win
    jmp printwin
winp1:
    mov si, msgp1win
printwin:
    lodsb
    cmp al, 0
    je winndone
    mov ah, 0x0E
    stosw
    jmp printwin
winndone:
    mov ah, 0x00
    int 0x16
    mov ax, 0x4c00
    int 0x21
nextline:
    add si, 3
    loop checkloop
    pop si
    pop cx
    pop bx
    pop ax
    ret