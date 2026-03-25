; Count ones in AX, repeat until AX=1, store iterations in BX
[org 0x100]
jmp start

start:
    mov ax, 0xC5A3      ; input (8 ones)
    mov bx, 0           ; iteration counter

outer:
    cmp ax, 1
    je done

    mov dx, 0           ; count of 1s
    mov cx, 16

inner:
    shr ax, 1
    jnc skip
    inc dx

skip:
    loop inner

    mov ax, dx          ; AX = count
    inc bx              ; iterations++
    jmp outer

done:
    mov ax, 0x4c00
    int 0x21