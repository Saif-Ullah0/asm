     1                                  [org 0x0100]
     2 00000000 E92700                  jmp start
     3                                  
     4 00000003 656E696C2072656874-     line1: db 'enil rehto na si siht'
     5 0000000C 6F206E612073692073-
     6 00000015 696874             
     7 00000018 656E696C2061207369-     line2: db 'enil a si siht'
     8 00000021 2073696874         
     9                                  
    10 00000026 1500                    len1: dw 21
    11 00000028 0E00                    len2: dw 14
    12                                  
    13                                  start:
    14 0000002A B800B8                      mov ax, 0xB800
    15 0000002D 8EC0                        mov es, ax
    16                                  
    17 0000002F BF0000                      mov di, 0
    18 00000032 BE[0300]                    mov si, line1
    19 00000035 8B0E[2600]                  mov cx, [len1]
    20 00000039 B407                        mov ah, 0x07
    21 0000003B 8A04                    l1: mov al, [si]
    22 0000003D 268905                      mov [es:di], ax
    23 00000040 81C70200                    add di, 2
    24 00000044 81C60100                    add si, 1
    25 00000048 E2F1                        loop l1
    26                                  
    27 0000004A BFA000                      mov di, 160
    28 0000004D BE[1800]                    mov si, line2
    29 00000050 8B0E[2800]                  mov cx, [len2]
    30 00000054 B407                        mov ah, 0x07
    31 00000056 8A04                    l2: mov al, [si]
    32 00000058 268905                      mov [es:di], ax
    33 0000005B 81C70200                    add di, 2
    34 0000005F 81C60100                    add si, 1
    35 00000063 E2F1                        loop l2
    36                                  
    37 00000065 B8004C                      mov ax, 0x4C00
    38 00000068 CD21                        int 0x21
