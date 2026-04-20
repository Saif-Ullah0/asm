\n===== FILE: ./ASM2/23065.asm =====\n
    org 0x100
    jmp start
    
    num1: dw 100, 200, 300, 400, 500, 600, 700, 800
          dw 101, 201, 301, 401, 501, 601, 701, 801
          dw 102, 202, 302, 402, 502, 602, 702, 802
          dw 103, 203, 303, 403, 503, 603, 703, 803
    
    num2: dw 10, 20, 30, 40, 50, 60, 70, 80
          dw 11, 21, 31, 41, 51, 61, 71, 81
          dw 12, 22, 32, 42, 52, 62, 72, 82
          dw 13, 23, 33, 43, 53, 63, 73, 83
    
    result: times 32 dw 0
    
    start:
        mov si, num1
        mov di, num2
        mov bx, result
        mov cx, 32
        clc
    
    add_loop:
        mov ax, [si]
        adc ax, [di]
        mov [bx], ax
        add si, 2
        add di, 2
        add bx, 2
    
        loop add_loop
    
        mov ax, 0x4C00
        int 0x21\n===== FILE: ./ASM3 512 mul/512mul.asm =====\n
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
\n===== FILE: ./hello.asm =====\n
    ; 16-bit COM file example
    ; nasm hello.asm -fbin -o hello.com
    ; to run in MS DOS / DosBox: hellocom.com
      org 100h 
     
    section .text 
     
    start:
      ; program code
      mov  dx, msg;  '$'-terminated string
      mov  ah, 09h; write string to standard output from DS:DX
      int  0x21   ; call dos services
     
      mov ax, 0x4C00
    int 0x21
     
    section .data
      ; program data
     
      msg  db 'Hello world'
      crlf db 0x0d, 0x0a
      endstr db '$'
     
    section .bss
      ; uninitialized data
\n===== FILE: ./Lab 04/BSCS23065 (1).asm =====\n
    [org 0x0100]
    jmp start
    
    array: dw 2,10,12,8,18,13,26,5,19
    size:  dw 9
    max:   dw 0
    smax:  dw 0
    min:   dw 0xFFFF
    smin:  dw 0xFFFF
    
    start:
        mov ax, [array]
        mov [max], ax
        mov [min], ax
    
        mov cx, [size]
        shl cx, 1
        mov bx, 0
    
    max_loop:
        mov ax, [array+bx]
        cmp ax, [max]
        jle chk_smax
        mov dx, [max]
        mov [smax], dx
        mov [max], ax
        jmp next
    
    chk_smax:
        cmp ax, [smax]
        jle next
        cmp ax, [max]
        je next
        mov [smax], ax
    
    next:
        add bx, 2
        cmp bx, cx
        jl max_loop
    
        mov bx, 0
    
    min_loop:
        mov ax, [array+bx]
        cmp ax, [min]
        jge chk_smin
        mov dx, [min]
        mov [smin], dx
        mov [min], ax
        jmp next2
    
    chk_smin:
        cmp ax, [smin]
        jge next2
        cmp ax, [min]
        je next2
        mov [smin], ax
    
    next2:
        add bx, 2
        cmp bx, cx
        jl min_loop
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab 04/BSCS23065 (2).asm =====\n
    [org 0x0100]
    jmp start
    
    array: dw 2,10,12,8,18,13,26,5,19
    size:  dw 9
    evenC: dw 0
    oddC:  dw 0
    
    start:
        mov cx, [size]
        shl cx, 1
        mov bx, 0
    
    count_loop:
        mov ax, [array+bx]
        test ax, 1
        jz isEven
    
    isOdd:
        inc word [oddC]
        jmp next
    
    isEven:
        inc word [evenC]
    
    next:
        add bx, 2
        cmp bx, cx
        jl count_loop
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab 04/BSCS23065 (3).asm =====\n
    [org 0x0100]
    jmp start
    
    array:    dw 2,10,12,8,18,13,26,5
    size:     dw 8
    mid_pos1: dw 0
    mid_pos2: dw 0
    element1: dw 0
    element2: dw 0
    median:   dw 0
    
    start:
        mov ax, [size]
        shr ax, 1
        mov [mid_pos1], ax
        inc ax
        mov [mid_pos2], ax
    
        mov cx, [size]
        shl cx, 1
        mov si, 0
    
    outer_loop:
        mov ax, [array+si]
        mov bx, 0
        mov dx, 0
    
    inner_loop:
        cmp bx, si
        je skip_self
        mov di, [array+bx]
        cmp di, ax
        jge skip_count
        inc dx
    
    skip_count:
    skip_self:
        add bx, 2
        cmp bx, cx
        jl inner_loop
    
        inc dx
    
        cmp dx, [mid_pos1]
        jne chk_pos2
        mov [element1], ax
    
    chk_pos2:
        cmp dx, [mid_pos2]
        jne next_elem
        mov [element2], ax
    
    next_elem:
        add si, 2
        cmp si, cx
        jl outer_loop
    
        mov ax, [element1]
        add ax, [element2]
        shr ax, 1
        mov [median], ax
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab 04/BSCS23065 (4).asm =====\n
    [org 0x0100]
    jmp start
    
    array:      dw 1,3,2,1,1,2,5,7,2,4,5,6,7,6
    size:       dw 14
    duplicates: times 14 dw 0
    dup_size:   dw 0
    distincts:  times 14 dw 0
    dist_size:  dw 0
    
    start:
        mov cx, [size]
        shl cx, 1
        mov si, 0
    
    outer_loop:
        mov ax, [array+si]
        mov bx, 0
        mov dx, 0
    
    count_loop:
        mov di, [array+bx]
        cmp di, ax
        jne skip
        inc dx
    skip:
        add bx, 2
        cmp bx, cx
        jl count_loop
    
        push si
        push cx
    
        ; check distincts
        mov di, 0
        mov cx, [dist_size]
        shl cx, 1
    
    chk_dist:
        cmp cx, 0
        je add_dist
        mov bx, [distincts+di]
        cmp bx, ax
        je done_dist
        add di, 2
        sub cx, 2
        jmp chk_dist
    
    add_dist:
        mov di, [dist_size]
        shl di, 1
        mov [distincts+di], ax
        inc word [dist_size]
    
    done_dist:
        ; check duplicates
        cmp dx, 1
        jle skip_dup
    
        mov di, 0
        mov cx, [dup_size]
        shl cx, 1
    
    chk_dup:
        cmp cx, 0
        je add_dup
        mov bx, [duplicates+di]
        cmp bx, ax
        je done_dup
        add di, 2
        sub cx, 2
        jmp chk_dup
    
    add_dup:
        mov di, [dup_size]
        shl di, 1
        mov [duplicates+di], ax
        inc word [dup_size]
    
    done_dup:
    skip_dup:
        pop cx
        pop si
        add si, 2
        cmp si, cx
        jl outer_loop
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab 04/BSCS23065 (5).asm =====\n
    [org 0x0100]
    jmp start
    
    array:     dw 2,10,12,8,18,13,26,5,19
    size:      dw 9
    evens:     times 9 dw 0
    positions: times 9 dw 0
    evencount: dw 0
    swapflag:  db 0
    
    start:
        mov cx, [size]
        shl cx, 1
        mov si, 0
    
    extract:
        mov ax, [array+si]
        test ax, 1
        jnz skip_extract
    
        mov bx, [evencount]
        shl bx, 1
        mov [evens+bx], ax
        mov [positions+bx], si
        inc word [evencount]
    
    skip_extract:
        add si, 2
        cmp si, cx
        jl extract
    
        mov cx, [evencount]
        dec cx
    
    outer:
        mov si, 0
        mov byte [swapflag], 0
    
    inner:
        mov bx, si
        shl bx, 1
    
        mov ax, [evens+bx]
        mov dx, [evens+bx+2]
        cmp ax, dx
        jle no_swap
    
        mov [evens+bx], dx
        mov [evens+bx+2], ax
    
        mov ax, [positions+bx]
        mov dx, [positions+bx+2]
        mov [positions+bx], dx
        mov [positions+bx+2], ax
    
        mov byte [swapflag], 1
    
    no_swap:
        inc si
        cmp si, cx
        jl inner
    
        cmp byte [swapflag], 1
        je outer
    
        mov si, 0
        mov cx, [evencount]
        shl cx, 1
    
    putback:
        mov bx, [positions+si]
        mov ax, [evens+si]
        mov [array+bx], ax
        add si, 2
        cmp si, cx
        jl putback
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab 04/BSCS23065 (6).asm =====\n
    [org 0x0100]
    jmp start
    
    array:        dw 1,3,2,1,1,2,5,7,2,4,5,6,7,6
    size:         dw 14
    unique:       times 14 dw 0
    freq:         times 14 dw 0
    unique_count: dw 0
    result:       times 14 dw 0
    swap_flag:    db 0
    
    start:
        mov cx, [size]
        shl cx, 1
        mov si, 0
    
    find_unique:
        mov ax, [array+si]
        push si
        push cx
        mov di, 0
        mov cx, [unique_count]
        shl cx, 1
    
    chk_unique:
        cmp cx, 0
        je add_unique
        mov bx, [unique+di]
        cmp bx, ax
        je found_unique
        add di, 2
        sub cx, 2
        jmp chk_unique
    
    add_unique:
        mov bx, [unique_count]
        shl bx, 1
        mov [unique+bx], ax
        mov word [freq+bx], 0
        inc word [unique_count]
    
    found_unique:
        pop cx
        pop si
        add si, 2
        cmp si, cx
        jl find_unique
    
        mov si, 0
        mov cx, [size]
        shl cx, 1
    
    count_freq:
        mov ax, [array+si]
        mov di, 0
        mov bx, [unique_count]
        shl bx, 1
    
    find_in_unique:
        mov dx, [unique+di]
        cmp dx, ax
        je inc_freq
        add di, 2
        sub bx, 2
        jnz find_in_unique
    
    inc_freq:
        inc word [freq+di]
        add si, 2
        cmp si, cx
        jl count_freq
    
        mov cx, [unique_count]
        dec cx
    
    sort_freq:
        mov si, 0
        mov byte [swap_flag], 0
    
    inner_sort:
        mov bx, si
        shl bx, 1
        mov ax, [freq+bx]
        mov dx, [freq+bx+2]
        cmp ax, dx
        jge no_swap
    
        mov [freq+bx], dx
        mov [freq+bx+2], ax
        mov ax, [unique+bx]
        mov dx, [unique+bx+2]
        mov [unique+bx], dx
        mov [unique+bx+2], ax
        mov byte [swap_flag], 1
    
    no_swap:
        inc si
        cmp si, cx
        jl inner_sort
        cmp byte [swap_flag], 1
        je sort_freq
    
        mov di, 0
        mov si, 0
        mov cx, [unique_count]
        shl cx, 1
    
    build_result:
        mov bx, si
        mov ax, [unique+bx]
        mov dx, [freq+bx]
    
    fill:
        mov [result+di], ax
        add di, 2
        dec dx
        jnz fill
    
        add si, 2
        cmp si, cx
        jl build_result
    
    mov ax, 0x4C00
    int 0x21\n===== FILE: ./Lab1/065.asm =====\n
    org 100h
    mov ax, 0
    mov cx, 16
    mov bx, num
    add_loop:
    add ax, [bx]
    add bx, 2
    loop add_loop
    shr ax, 1
    mov ax, 4c00h
    int 21h
    num: dw 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8
        dw 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10\n===== FILE: ./Lab2/23065Q1.asm =====\n
    [org 0x0100]
    
        mov ax, 0
        add ax, 4
        add ax, 4
        add ax, 4
        add ax, 4
    
        mov ax, 0x4c00
        int 0x21\n===== FILE: ./Lab2/23065Q2.asm =====\n
    [org 0x0100]
    
        mov ax, [num1]
        add ax, [num2]
        add ax, [num3]
        add ax, [num4]
    
        mov ax, 0x4c00
        int 0x21
    
    num1: dw 5
    num2: dw 10
    num3: dw 15
    num4: dw 20\n===== FILE: ./Lab2/23065Q4.asm =====\n
    [org 0x0100]
    
        mov bx, [num]
        mov cx, [num]
        mov ax, 0
    
    square_loop:
        add ax, [num]
        sub cx, 1
        jnz square_loop
    
        mov dx, ax
        mov cx, [num]
        mov ax, 0
    
    cube_loop:
        add ax, dx
        sub cx, 1
        jnz cube_loop
    
        mov [result], ax
    
        mov ax, 0x4c00
        int 0x21
    
    num: dw 5
    result: dw 0\n===== FILE: ./Lab3/23065Q1.asm =====\n
    
    [org 0x0100]
    
    
    mov al, [n1]
    add al, [n2]
    add al, 7
    
    mov [ans], al
    mov [wans], ax
    mov ax,0x4c00
    int 0x21
    
    
    n1 : db 5
    n2 : db 8 
    ans : db 0
    wans : dw 0\n===== FILE: ./Lab3/23065Q3.asm =====\n
    [org 0x100]
    
    mov si, arr
    mov al, [si]
    mov bl, [si]
    mov cx, 9
    add si, 1
    
    loops:
    mov dl, [si]
    cmp dl,al
    jle nmax
    mov al,dl
    
    nmax:
    cmp dl, bl
    jge nmin
    mov bl,dl
    
    nmin:
    add si,1
    loop loops
    
    mov [max],al
    mov [min],bl
    
    mov ax, 0x4c00
    int 0x21
    
    arr: db 7, 2, 3, 4, 1, 5, 6, 9, 8, 0
    max :db 0
    min : db 0
    
\n===== FILE: ./Lab3/23065Q5.asm =====\n
    [org 0x100]
    
    mov word [left], 0
    mov word [right], 9
    
    search:
    mov ax, [left]
    cmp ax,[right]
    jg none
    
    mov ax,[left]
    add ax,[right]
    shr ax,1
    mov [mid], ax
    
    mov bx,[mid]
    shl bx,1
    mov ax,[arr+bx]
    
    cmp ax,[target]
    je find
    jl searchRight
    jg searchLeft
    
    find:
    mov ax,[mid]
    jmp exit
    
    searchRight:
    mov ax,[mid]
    inc ax
    mov [left],ax
    jmp search
    
    
    
    searchLeft:
    mov ax,[mid]
    dec ax
    mov [right],ax
    jmp search
    
    none:
    mov ax,-1
    jmp exit
    
    exit:
    mov bx,ax
    mov ax, 0x4c00
    int 0x21
    
    arr: dw 0, 1, 2, 5, 7, 9, 12, 15, 16, 20
    target: dw 12
    left: dw 0
    right: dw 0
    mid: dw 0\n===== FILE: ./Lab3/Q6.asm =====\n
\n===== FILE: ./LAB5/23065 (1).asm =====\n
    [org 0x0100]
    jmp start
    
    arr:  db 1,3,5,7,9,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
    size: dw 20
    sum:  dw 0
    
    start:
        mov bx, arr
        mov cx, [size]
    
    loopS:
        mov ax, bx
        mov dx, 0
        mov di, 3
        div di
        cmp dx, 0
        jne skip
    
        mov al, [bx]
        mov ah, 0
        add [sum], ax
    
    skip:
        inc bx
        loop loopS
    
        mov ax, 0x4C00
        int 0x21\n===== FILE: ./LAB5/23065 (2).asm =====\n
    [org 0x0100]
    jmp start
    
    arr:  db 1,3,5,7,9,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
    size: dw 20
    sum:  dw 0
    
    start:
        mov bx, arr
        mov cx, [size]
    
    sum_loop:
        mov al, [bx]
        mov ah, 0
        add [sum], ax
        inc bx
        loop sum_loop
    
        mov ax, [sum]
        and ax, 0x000F       
        mov bx, ax         
    
        mov cx, bx           
        mov dx, 1
        shl dx, cl           
        xor bx, dx           
    
        mov ax, 0x4C00
        int 0x21\n===== FILE: ./LAB5/23065 (3).asm =====\n
    [org 0x0100]
    jmp start
    
    num1:   dw 46080
    num2:   dw 31713
    count0: dw 0
    count1: dw 0
    
    start:
        mov ax, [num1]
        mov cx, 16
    
    loop0:
        shr ax, 1
        jc skip0
        inc word [count0]
    skip0:
        loop loop0
    
        mov ax, [num2]
        mov cx, 16
    
    loop1:
        shr ax, 1
        jnc skip1
        inc word [count1]
    skip1:
        loop loop1
    
        mov ax, 0x4C00
        int 0x21
\n===== FILE: ./LAB5/23065 (4).asm =====\n
    [org 0x0100]
    jmp start
    
    seed:   dw 0
    result: dw 0
    
    start:
        mov ax, [seed]
        mov [result], ax
    
        mov bx, ax
        and bx, 0x4000
        shr bx, 14
    
        mov dx, ax
        and dx, 0x8000
        shr dx, 15
    
        xor bx, dx
    
        and ax, 0xFFFE
        or  ax, bx
    
        mov [result], ax
    
        mov ax, 0x4C00
        int 0x21
\n===== FILE: ./LAB5/23065 (5).asm =====\n
    [org 0x0100]
    jmp start
    
    num:    dw 0x0039
    result: dw 0
    
    start:
        mov ax, [num]
        mov bx, ax
        mov dx, 0
        mov cx, 16
    
    reverse_loop:
        shr bx, 1
        rcl dx, 1
        loop reverse_loop
    
        cmp ax, dx
        je is_palindrome
    
    not_palindrome:
        mov ax, 0
        jmp exit
    
    is_palindrome:
        mov ax, 1
    
    exit:
        mov [result], ax
        mov ax, 0x4C00
        int 0x21
\n===== FILE: ./Lab6/23065 (1).asm =====\n
    [org 0x100]
    
    jmp start
    
    start:
    mov ax, 0x123
    mov bl, al
    mov cl, 8
    
    reverse:
    shl bl, 1
    rcl al, 1
    loop reverse
    
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/23065 (2).asm =====\n
    [org 0x100]
    
    jmp start
    
    start:
    mov ax, 0x1234
    mov cx, 16
    mov bx,0
    mov dx,0 
    
    loop1:
    shl ax,1
    jnc reset
    
    inc dx
    cmp dx,bx
    jle skip
    mov bx,dx
    jmp skip
    
    reset:
    mov dx,0
    
    skip:
    loop loop1
    
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/23065 (3).asm =====\n
    ;Write a program to swap first 4 bits with the last 4 bits in AX.
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0x1234
    mov bx,ax
    and ax,0x000F
    shl ax,12
    and bx,0xF000
    shr bx,12
    or ax,bx
    
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/23065 (4).asm =====\n
    ;Write a program to toggle only the even-positioned bits in AX.
    
    [org 0x100]
    jmp start
    
    start:
    mov ax,0x1234
    xor ax,0x5555
    
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/23065 (5).asm =====\n
    [org 0x100]
    jmp start
    
    start:
        mov ax, 0xD6AE      
        mov cl, 4           
        mov dl, 11          
    
        ; shr by i
        shr ax, cl
    
        ; build mask j-i+1
        mov bl, dl
        sub bl, cl
        inc bl
    
        mov cl, bl
        mov bx, 1
        shl bx, cl
        dec bx
    
        and ax, bx
        mov bx, ax
    
        mov ax, 0x4c00
        int 0x21\n===== FILE: ./Lab6/23065 (6).asm =====\n
    ;Write a program to swap every pair of bits in the AX register
    
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0X1234
    mov bx, ax
    and ax, 0xAAAA
    shr ax, 1
    
    and bx, 0x5555
    shl bx, 1
    or ax, bx
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/23065 (7).asm =====\n
    ;Write a program to swap the nibbles in each byte of the AX register.
    
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0x1234
    mov bx, ax
    and ax, 0xF0F0
    shl ax, 4
    and bx, 0x0F0F
    shr bx, 4
    or ax, bx
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/23065 (8).asm =====\n
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
        int 0x21\n===== FILE: ./Lab6/6q1.asm =====\n
    [org 0x100]
    
    jmp start
    
    start:
    mov ax, 0x123
    mov bl, al
    mov cl, 8
    
    reverse:
    shl bl, 1
    rcl al, 1
    loop reverse
    
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/6q2.asm =====\n
    [org 0x100]
    
    jmp start
    
    start:
    mov ax, 0x1234
    mov cx, 16
    mov bx,0
    mov dx,0 
    
    loop1:
    shl ax,1
    jnc reset
    
    inc dx
    cmp dx,bx
    jle skip
    mov bx,dx
    jmp skip
    
    reset:
    mov dx,0
    
    skip:
    loop loop1
    
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/6q3.asm =====\n
    ;Write a program to swap first 4 bits with the last 4 bits in AX.
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0x1234
    mov bx,ax
    and ax,0x000F
    shl ax,12
    and bx,0xF000
    shr bx,12
    or ax,bx
    
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/6q4.asm =====\n
    ;Write a program to toggle only the even-positioned bits in AX.
    
    [org 0x100]
    jmp start
    
    start:
    mov ax,0x1234
    xor ax,0x5555
    
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/6q5.asm =====\n
    [org 0x100]
    jmp start
    
    start:
        mov ax, 0xD6AE      
        mov cl, 4           
        mov dl, 11          
    
        ; shr by i
        shr ax, cl
    
        ; build mask j-i+1
        mov bl, dl
        sub bl, cl
        inc bl
    
        mov cl, bl
        mov bx, 1
        shl bx, cl
        dec bx
    
        and ax, bx
        mov bx, ax
    
        mov ax, 0x4c00
        int 0x21\n===== FILE: ./Lab6/6q6.asm =====\n
    ;Write a program to swap every pair of bits in the AX register
    
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0X1234
    mov bx, ax
    and ax, 0xAAAA
    shr ax, 1
    
    and bx, 0x5555
    shl bx, 1
    or ax, bx
    mov ax, 0x4c00
    int 0x21
\n===== FILE: ./Lab6/6q7.asm =====\n
    ;Write a program to swap the nibbles in each byte of the AX register.
    
    [org 0x100]
    jmp start
    
    start:
    mov ax, 0x1234
    mov bx, ax
    and ax, 0xF0F0
    shl ax, 4
    and bx, 0x0F0F
    shr bx, 4
    or ax, bx
    mov ax, 0x4c00
    int 0x21\n===== FILE: ./Lab6/6q8.asm =====\n
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
        int 0x21\n===== FILE: ./Lab7/BSCS23065 (1).asm =====\n
    [org 0x100]
    
    start:
        mov al,0ACh
        mov bl,05h
        xor dx,dx
        mov cx,8
        clc 
    
    interleave_loop:
        shl al,1 
        rcl dx,1
        shl bl,1
        rcl dx,1
        loop interleave_loop
    
    mov ax,dx
    
    
    mov ax,0x4C00
    int 0x21\n===== FILE: ./Lab7/BSCS23065 (2).asm =====\n
    [org 0x100]
    
    start:
        mov ax, 0ABCDh  
        shr ax, 5
        and ax, 3Fh
        mov bl, al     
    
    mov ax, 0x4C00
    int 0x21            \n===== FILE: ./Lab7/BSCS23065 (3).asm =====\n
    [org 0x100]
    
    start:
        mov dx, 1234h  
        mov ax, 5678h 
        shl ax, 1
        rcl dx, 1
    
    mov ax, 0x4C00
    int 0x21
\n===== FILE: ./Lab7/BSCS23065 (4).asm =====\n
    [org 0x100]
    
    start:
        mov ax, 1234h
        mov cl, 4
        
        rol ax, cl
        xor ax, 0A5A5h
        ror ax, 3
        
        mov dx, ax
        
        mov ax, 0x4C00
        int 0x21
\n===== FILE: ./Lab7/BSCS23065 (5).asm =====\n
    [org 0x100]
    
    start:
        mov ax, 0ABD5h
        xor bx, bx
        mov dl, 0
    
    check_loop:
        mov si, ax
        mov cl, dl
        shr si, cl
        and si, 7
        cmp si, 5
        jne next
        inc bx
    
    next:
        inc dl
        cmp dl, 14
        jl check_loop
    
        mov cx, bx
    
        mov ax, 0x4C00
        int 0x21\n===== FILE: ./Lab7/BSCS23065 (6).asm =====\n
    [org 0x100]
    
    start:
        mov al, 0B6h
        and al, 0Fh
        
        mov ax, 0x4C00
        int 0x21
\n===== FILE: ./Lab8/8q1.asm =====\n
    [org 0x100]
    jmp start
    
    data: dw 1, 2, 3, 4, 5
    
    start:
        mov ax, data
        push ax
        mov ax, 5
        push ax
        call reverse
        
        mov ax, 0x4C00
        int 0x21
    
    reverse:
        push bp
        mov bp, sp
        push bx
        push cx
        push si
    
        mov bx, [bp+6]
        mov cx, [bp+4]
    
        mov si, 0
        mov dx, cx
    
    push_loop:
        push word [bx+si]
        add si, 2
        loop push_loop
    
        mov si, 0
        mov cx, dx
    
    pop_loop:
        pop word [bx+si]
        add si, 2
        loop pop_loop
    
        pop si
        pop cx
        pop bx
        mov sp, bp
        pop bp
        ret 4\n===== FILE: ./Lab8/8q2.asm =====\n
    [org 0x100]
    jmp start
    
    start:
        mov ax, 1234h
        push ax
        call bitswap
    
        pop ax
        
        mov ax, 0x4C00
        int 0x21
    
    bitswap:
        push bp
        mov bp, sp
        sub sp, 2
        push ax
        push bx
        push cx
    
        mov ax, [bp+4]
        mov [bp-2], ax
    
        call swapbits_1_15
        call swapbits_3_13
        call swapbits_5_11
        call swapbits_7_9
    
        mov ax, [bp-2]
        mov [bp+4], ax
    
        pop cx
        pop bx
        pop ax
        mov sp, bp
        pop bp
        ret
    
    swapbits_1_15:
        push ax
        push bx
        mov ax, [bp-2]
        mov bx, ax
        shr bx, 14
        xor bx, ax
        and bx, 0002h
        xor ax, bx
        mov bx, ax
        shl bx, 14
        xor bx, ax
        and bx, 8000h
        xor ax, bx
        mov [bp-2], ax
        pop bx
        pop ax
        ret
    
    swapbits_3_13:
        push ax
        push bx
        mov ax, [bp-2]
        mov bx, ax
        shr bx, 10
        xor bx, ax
        and bx, 0008h
        xor ax, bx
        mov bx, ax
        shl bx, 10
        xor bx, ax
        and bx, 2000h
        xor ax, bx
        mov [bp-2], ax
        pop bx
        pop ax
        ret
    
    swapbits_5_11:
        push ax
        push bx
        mov ax, [bp-2]
        mov bx, ax
        shr bx, 6
        xor bx, ax
        and bx, 0020h
        xor ax, bx
        mov bx, ax
        shl bx, 6
        xor bx, ax
        and bx, 0800h
        xor ax, bx
        mov [bp-2], ax
        pop bx
        pop ax
        ret
    
    swapbits_7_9:
        push ax
        push bx
        mov ax, [bp-2]
        mov bx, ax
        shr bx, 2
        xor bx, ax
        and bx, 0080h
        xor ax, bx
        mov bx, ax
        shl bx, 2
        xor bx, ax
        and bx, 0200h
        xor ax, bx
        mov [bp-2], ax
        pop bx
        pop ax
        ret\n===== FILE: ./Lab8/8q3.asm =====\n
    [org 0x100]
    jmp start
    
    start:
        mov ax, 0B6h
        push ax
        call remove_dups
    
        pop ax
        
        mov ax, 0x4C00
        int 0x21
    
    remove_dups:
        push bp
        mov bp, sp
        push bx
        push cx
        push dx
        push si
    
        mov ax, [bp+4]
        xor bx, bx
        xor si, si
        mov cx, 16
        mov dx, ax
        shr dx, 15
    
    bit_loop:
        shl ax, 1
        jc bit_is_1
    
    bit_is_0:
        cmp dx, 0
        je skip_bit
        mov dx, 0
        jmp add_bit
    
    bit_is_1:
        cmp dx, 1
        je skip_bit
        mov dx, 1
    
    add_bit:
        rcl bx, 1
        inc si
        loop bit_loop
        jmp done_loop
    
    skip_bit:
        loop bit_loop
    
    done_loop:
        mov [bp+4], bx
    
        pop si
        pop dx
        pop cx
        pop bx
        mov sp, bp
        pop bp
        ret\n===== FILE: ./Lab8/8q4.asm =====\n
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
        ret 2\n===== FILE: ./Lab8/8q5.asm =====\n
    [org 0x100]
    jmp start
    
    start:
        mov ax, 0ABCDh
        call splitter
        
        mov ax, 0x4C00
        int 0x21
    
    splitter:
        push cx
        push dx
        push si
        push di
    
        xor bx, bx
        xor si, si
        xor di, di
        mov cx, 16
        mov dx, ax
    
    bit_loop:
        shr dx, 1
        jnc its_zero
    
    its_one:
        mov ax, 16
        sub ax, cx
        test ax, 1
        jnz odd_bit
    
    even_bit:
        push cx
        mov cx, si
        mov ax, 1
        shl ax, cl
        or bl, al
        pop cx
        inc si
        jmp next_bit
    
    odd_bit:
        push cx
        mov cx, di
        mov ax, 1
        shl ax, cl
        or bh, al
        pop cx
        inc di
        jmp next_bit
    
    its_zero:
        mov ax, 16
        sub ax, cx
        test ax, 1
        jnz inc_odd
        inc si
        jmp next_bit
    inc_odd:
        inc di
    
    next_bit:
        loop bit_loop
    
        pop di
        pop si
        pop dx
        pop cx
        ret\n===== FILE: ./Lab9/23065 (1).asm =====\n
    [org 0x100]
    jmp start
    
    block1: db 1, 2, 3, 4, 5
    block2: db 1, 2, 3, 4, 5
    
    start:
        mov ax, block1
        push ax
        mov ax, block2
        push ax
        mov ax, 5
        push ax
        call memcompare
        
        mov ax, 0x4C00
        int 0x21
    
    memcompare:
        push bp
        mov bp, sp
        push si
        push di
        push cx
    
        mov si, [bp+8]
        mov di, [bp+6]
        mov cx, [bp+4]
    
    cmp_loop:
        mov al, [si]
        cmp al, [di]
        jne mismatch
        inc si
        inc di
        loop cmp_loop
    
        mov ax, 0
        jmp cmp_done
    
    mismatch:
        mov ax, 1
    
    cmp_done:
        pop cx
        pop di
        pop si
        pop bp
        ret 6
\n===== FILE: ./Lab9/23065 (2).asm =====\n
    [org 0x100]
    
    start:
        mov ax, 10
        mov bx, 20
    
        mov cx, after_add
        push cx
        jmp do_add
    
    after_add:
        mov ax, 0x4C00
        int 0x21
    
    do_add:
        add ax, bx
        
        pop cx
        jmp cx
\n===== FILE: ./Lab9/23065 (3).asm =====\n
    [org 0x100]
    jmp start
    
    data:    db 10101000b
    pattern: dw 101b
    
    start:
        mov ax, data
        push ax
        mov ax, 1
        push ax
        mov ax, 101b
        push ax
        mov ax, 3
        push ax
        call bitsearch
    
        mov ax, 0x4C00
        int 0x21
    
    bitsearch:
        push bp
        mov bp, sp
        push bx
        push cx
        push dx
        push si
        push di
    
        mov si, [bp+10]
        mov bx, [bp+8]
        mov dx, [bp+6]
        mov cx, [bp+4]
    
        xor ah, ah
        mov al, bl
        mov bl, 8
        mul bl
        xor bh, bh
        mov bl, cl
        sub ax, bx
        inc ax
        mov bx, ax
    
        xor di, di
    
    search_loop:
        call extract_bits
        cmp ax, dx
        je found
        inc di
        dec bx
        jnz search_loop
        xor ax, ax
        jmp search_done
    
    found:
        mov ax, di
        inc ax
    
    search_done:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop bp
        ret 8
    
    extract_bits:
        push bx
        push cx
        push dx
        push si
        push di
    
        xor bx, bx
        mov ch, cl
        xor cl, cl
    
    next_bit:
        cmp cl, ch
        jge eb_done
    
        mov ax, di
        shr ax, 3
        mov bx, si
        add bx, ax
        mov al, [bx]
    
        mov dx, di
        and dl, 7
        mov dh, 7
        sub dh, dl
        push cx
        mov cl, dh
        shr al, cl
        pop cx
        and al, 1
    
        shl bx, 1
        or bl, al
    
        inc di
        inc cl
        jmp next_bit
    
    eb_done:
        mov ax, bx
    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        ret\n===== FILE: ./Lab9/23065 (4).asm =====\n
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
\n===== FILE: ./Lab9/23065 (5).asm =====\n
    ; Task 5: Safe memory swap using stack
    [org 0x100]
    jmp start
    
    block1: db 1, 2, 3, 4, 5
    block2: db 6, 7, 8, 9, 10
    
    start:
        mov ax, block1
        push ax
        mov ax, block2
        push ax
        mov ax, 5
        push ax
        call memswap
        
        mov ax, 0x4C00
        int 0x21
    
    memswap:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push si
        push di
    
        mov si, [bp+8]
        mov di, [bp+6]
        mov cx, [bp+4]
    
        push cx
        mov bx, cx
    
    push_loop:
        mov al, [si + bx - 1]
        xor ah, ah
        push ax
        dec bx
        jnz push_loop
        pop cx
    
        push cx
        mov si, [bp+8]
        mov di, [bp+6]
    
    copy_loop:
        mov al, [di]
        mov [si], al
        inc si
        inc di
        loop copy_loop
        pop cx
    
        mov si, [bp+8]
        mov di, [bp+6]
    
    pop_loop:
        pop ax
        mov [di], al
        inc di
        loop pop_loop
    
        pop di
        pop si
        pop cx
        pop bx
        pop ax
        pop bp
        ret 6
\n===== FILE: ./rtn.asm =====\n
    ;NASM Win32 resource sample
    ; compile and link with 
    ;
    ;nasm -fobj rtn.asm
    ;
    ;alink -oPE rtn win32.lib rtn.res
    
    
    [extern DialogBoxParamA]
    [extern GetModuleHandleA]
    [extern ExitProcess]
    [extern EndDialog]
    
    WM_INITDIALOG equ 0110h
    WM_COMMAND equ 0111h
    
    IDOK equ 1
    
    [segment code public use32 class='CODE']
    
    ..start:
    enter 0,0
    push byte 0
    call GetModuleHandleA
    mov [handle],eax
    push byte 0
    push dword DProc
    push byte 0
    push dword string
    push byte 0
    call DialogBoxParamA
    push dword [handle]
    call ExitProcess
    leave
    ret
    
    DProc:
    %define lparam ebp+20
    %define wparam ebp+16
    %define msg ebp+12
    %define hdlg ebp+8
     enter 0,0
     mov eax,[msg]
     cmp eax,WM_INITDIALOG
     je @@wm_init
     cmp eax,WM_COMMAND
     je @@wm_command
    @@unhandled:
     xor eax,eax
     leave
     ret 16
    @@wm_init:
     mov eax,1
     leave
     ret 16
    @@wm_command:
     cmp dword [wparam],IDOK
     jne @@unhandled
     push byte 1
     push dword [hdlg]
     call EndDialog
     mov eax,1
     leave
     ret 16
    
    [segment data public]
    handle dd 0
    string db 'ABOUTDLG',0
\n===== FILE: ./SS.asm =====\n
    [org 0x0100]
    jmp start
    arr: dw 60, -5, 45, -20, 40, 35, -10, 30, 10, 20
    swap: db 0
    
    start:
        mov bx, 0
        mov byte [swap], 0
    
    loop1:
        mov ax, [arr+bx]
        cmp ax, [arr+bx+2]
        jle noswap              
    
        mov dx, [arr+bx+2]
        mov [arr+bx+2], ax
        mov [arr+bx], dx
        mov byte [swap], 1
    
    noswap:
        add bx, 2
        cmp bx, 18
        jne loop1
    
        cmp byte [swap], 1
        je start
    
        mov ax, 0x4c00
        int 0x21\n===== FILE: ./tcoff.asm =====\n
    ;Sample COFF object file
    ;assemble with
    ;NASM -fwin32 tcoff.asm
    ;link with
    ;ALINK -oPE tcoff win32.lib -entry main
    
    [extern MessageBoxA]
    [extern __imp_MessageBoxA]
    
    [segment .text]
    [global main]
    
    main:
    push dword 0 ; OK button
    push dword title1
    push dword string1
    push dword 0
    call MessageBoxA
    
    push dword 0 ; OK button
    push dword title1
    push dword string2
    push dword 0
    call [__imp_MessageBoxA]
    
    ret
    
    [segment .data]
    
    string1: db 'hello world, through redirection',13,10,0
    title1: db 'Hello',0
    string2: db 'hello world, called through import table',13,10,0
    
\n===== FILE: ./US.asm =====\n
    [org 0x0100]
    jmp start
    arr: dw 60, 55, 45, 50, 40, 35, 25, 30, 10, 20
    swap: db 0
    
    start:
        mov bx, 0
        mov byte [swap], 0
    
    loop1:
        mov ax, [arr+bx]
        cmp ax, [arr+bx+2]
        jbe noswap              
    
        mov dx, [arr+bx+2]
        mov [arr+bx+2], ax
        mov [arr+bx], dx
        mov byte [swap], 1
    
    noswap:
        add bx, 2
        cmp bx, 18
        jne loop1
    
        cmp byte [swap], 1
        je start
    
        mov ax, 0x4c00
        int 0x21