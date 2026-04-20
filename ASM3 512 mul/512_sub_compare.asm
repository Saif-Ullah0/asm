[org 0x0100]

; 512-bit unsigned subtractor and comparator
; compare512: AX = 0 if equal, 0FFFFh if less, 0001h if greater
; subtract512: subtracts second 512-bit number from first and stores result in diff

start:
    ; Example data: num1 and num2 are 512-bit values stored as 32 words (little-endian)
    mov si, offset num1
    mov di, offset num2
    mov bx, offset diff
    call subtract512

    mov si, offset num1
    mov di, offset num2
    call compare512
    ; result in AX after compare512

    mov ax, 0x4C00
    int 0x21

;--------------------------------------------
; subtract512
; Inputs: SI -> low word of first 512-bit unsigned number
;         DI -> low word of second 512-bit unsigned number
;         BX -> low word of output difference array
; Output: difference stored in [BX..BX+63]
; Clobbers: AX, CX
subtract512:
    clc                 ; clear borrow
    mov cx, 32          ; 32 words in 512 bits
sub_loop:
    mov ax, [si]
    sbb ax, [di]
    mov [bx], ax
    add si, 2
    add di, 2
    add bx, 2
    loop sub_loop
    ret

;--------------------------------------------
; compare512
; Inputs: SI -> low word of first 512-bit unsigned number
;         DI -> low word of second 512-bit unsigned number
; Output: AX = 0 if equal, 0FFFFh if first < second, 0001h if first > second
; Clobbers: CX, DX, AX
compare512:
    mov cx, 32
    lea si, [si + 2*31] ; point to highest word of first number
    lea di, [di + 2*31] ; point to highest word of second number
compare_loop:
    mov ax, [si]
    cmp ax, [di]
    ja compare_greater
    jb compare_less
    sub si, 2
    sub di, 2
    loop compare_loop
    mov ax, 0
    ret

compare_less:
    mov ax, 0FFFFh
    ret

compare_greater:
    mov ax, 1
    ret

;--------------------------------------------
; 512-bit unsigned numbers in little-endian word order
num1:
    dw 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000

num2:
    dw 0x0000, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    dw 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000

; difference output area
diff:
    times 32 dw 0
