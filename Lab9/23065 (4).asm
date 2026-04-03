; Task 4: Merge two sorted arrays
[org 0x100]
jmp start

arr1:   dw 1, 3, 5, 7
arr2:   dw 2, 4, 6, 8
res:    times 8 dw 0

start:
    mov ax, arr1
    push ax
    mov ax, arr2
    push ax
    mov ax, 4
    push ax
    mov ax, 4
    push ax
    mov ax, res
    push ax
    call merge_sorted
    
    mov ax, 0x4C00
    int 0x21

merge_sorted:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, [bp+14]
    mov di, [bp+12]
    mov cx, [bp+10]
    mov dx, [bp+8]
    mov bx, [bp+6]

merge_loop:
    cmp cx, 0
    je copy_arr2
    cmp dx, 0
    je copy_arr1

    mov ax, [si]
    cmp ax, [di]
    jle take_arr1

take_arr2:
    mov ax, [di]
    mov [bx], ax
    add di, 2
    add bx, 2
    dec dx
    jmp merge_loop

take_arr1:
    mov ax, [si]
    mov [bx], ax
    add si, 2
    add bx, 2
    dec cx
    jmp merge_loop

copy_arr1:
    cmp cx, 0
    je merge_done
    mov ax, [si]
    mov [bx], ax
    add si, 2
    add bx, 2
    dec cx
    jmp copy_arr1

copy_arr2:
    cmp dx, 0
    je merge_done
    mov ax, [di]
    mov [bx], ax
    add di, 2
    add bx, 2
    dec dx
    jmp copy_arr2

merge_done:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 10
