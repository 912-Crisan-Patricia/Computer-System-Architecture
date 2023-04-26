bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    a dw 1100110011001100b
    b dd 0
segment code use32 class=code
start:;Given the word A, compute the doubleword B as follows:
      ;the bits 0-3 of B have the value 0;
      ;the bits 4-7 of B are the same as the bits 8-11 of A
      ;the bits 8-9 and 10-11 of B are the invert of the bits 0-1 of A (so 2 times) ;
      ;the bits 12-15 of B have the value 1
      ;the bits 16-31 of B are the same as the bits 0-15 of B.

    ;the bits 0-3 of B have the value 0;
    
    mov bx, 0
    and bx, 1111111111110000b 
    
    ;the bits 4-7 of B are the same as the bits 8-11 of A
    
    mov ax, [a]
    and ax, 0000111100000000b   ;retain bits 8-11 from a
    mov cl, 4
    ror ax, cl                  ;move bits into positions 4-7
    or bx, ax                   ;retain value in bx
    
    ;the bits 8-9 and 10-11 of B are the invert of the bits 0-1 of A (so 2 times) ;
    
    mov ax, [a]                         ; ax = a
    not ax                              ; inverts values from a
    and ax, 0000_0000_0000_0011b        ; saves bits 0-1 from a
    shl ax, 8                           ; shifts bits 0-1 to 8-9
    or bx, ax                          ; retains values in b
    shl ax, 2                           ; shifts bits 8-9 to 10-11
    or bx, ax                          ; saves values in b
    
    ;the bits 16-31 of B are the same as the bits 0-15 of B.
    
    mov eax, 0
    mov ax, bx           ; ax = b
    mov cl, 16
    rol eax, cl            ; moves b from bits 0-15 to 16-31
    mov ax, bx            ; adds in eax on positions 0-15 b
    
    
    push dword 0 
    call [exit] 