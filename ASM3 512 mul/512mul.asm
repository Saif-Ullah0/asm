[org 0x100]
jmp start

num1:   times 32 dw 0xFFFF
num2:   times 32 dw 0xFFFF
result: times 64 dw 0

start:
    xor si, si

outer_loop:
    xor di, di

inner_loop:
    mov ax, [si + num1]
    mov bx, [di + num2]
    call multiply16

    mov bx, si
    add bx, di
    call add32_to_result

    add di, 2
    cmp di, 64
    jl inner_loop

    add si, 2
    cmp si, 64
    jl outer_loop

    mov ax, 0x4C00
    int 0x21

multiply16:
    push cx
    push si

    xor dx, dx
    mov si, bx
    xor bx, bx
    mov cx, 16

mul16_loop:
    test ax, 1
    jz mul16_skip

    add bx, si
    adc dx, 0

mul16_skip:
    shl si, 1
    adc dx, 0

    shr ax, 1
    loop mul16_loop

    mov ax, bx
    pop si
    pop cx
    ret

add32_to_result:
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, bx
    add si, result

    add ax, [si]
    mov [si], ax

    adc dx, [si + 2]
    mov [si + 2], dx

    jnc add32_done

    add si, 4

carry_prop:
    cmp si, result + 128
    jge add32_done
    inc word [si]
    jnc add32_done
    add si, 2
    jmp carry_prop

add32_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
