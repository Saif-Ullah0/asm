[org 0x100]
jmp start

data: dw 4, 3, 5, 6, 7, 8

start:
    mov ax, data
    push ax
    mov ax, 6
    push ax
    call rev_primes
    
    mov ax, 0x4C00
    int 0x21

rev_primes:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di

    mov bx, [bp+6]
    mov cx, [bp+4]
    xor si, si
    xor di, di

scan_loop:
    mov ax, [bx+si]
    push ax
    call is_prime
    cmp ax, 1
    jne not_prime
    push word [bx+si]
    inc di

not_prime:
    add si, 2
    loop scan_loop

    mov cx, [bp+4]
    xor si, si

refill_loop:
    mov ax, [bx+si]
    push ax
    call is_prime
    cmp ax, 1
    jne not_prime2
    pop word [bx+si]

not_prime2:
    add si, 2
    loop refill_loop

    pop di
    pop si
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 4

is_prime:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx

    mov ax, [bp+4]
    cmp ax, 2
    jl not_p
    je is_p
    mov cx, 2

div_loop:
    mov dx, 0
    mov bx, cx
    div bx
    cmp dx, 0
    je not_p
    inc cx
    mov ax, [bp+4]
    mov bx, cx
    mul bx
    cmp ax, [bp+4]
    jg is_p
    mov ax, [bp+4]
    jmp div_loop

is_p:
    mov ax, 1
    jmp prime_done
not_p:
    mov ax, 0

prime_done:
    pop dx
    pop cx
    pop bx
    mov sp, bp
    pop bp
    ret 2