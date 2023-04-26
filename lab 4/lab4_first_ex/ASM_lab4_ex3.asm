bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    a dw 1100110011001100b
    b dw 1010101010101010b
    c dq 0
segment code use32 class=code
start:  ;Given the words A and B, compute the doubleword C as follows:
        ;the bits 0-2 of C are the same as the bits 12-14 of A
        ;the bits 3-8 of C are the same as the bits 0-5 of B
        ;the bits 9-15 of C are the same as the bits 3-9 of A
        ;the bits 16-31 of C are the same as the bits of A
        
    mov bx, 0                   ; bx = 0
    
    ;the bits 0-2 of C are the same as the bits 12-14 of A
    
    mov ax, [a]                 ; ax = a
    and ax, 0111000000000000b   ; izolate bits 12-14 from a
    mov cl, 12
    ror ax, cl                  ; move bits 12-14 from a to 0-2 position
    or  bx, ax                   ; bx = ax
    
    ;the bits 3-8 of C are the same as the bits 0-5 of B
    
    mov ax, [b]                 ; ax = b
    and ax, 0000000000111111b   ; izolate bits 0-5 from b
    mov cl, 3
    rol ax, cl                  ; rotate the bits from b into bits 3-8 
    or  bx, ax                   ; put the bits into result
    
    ;the bits 9-15 of C are the same as the bits 3-9 of A
    
    mov ax, [a]                 ; ax = a
    and ax, 000001111111000b    ; izolate bits 3-9 from a
    mov cl, 6
    rol ax, cl                  ; move bits 3-9 from a to 9-15 position
    or  bx, ax                   ;put the bits into result
    
    ;the bits 16-31 of C are the same as the bits of A
    
    mov eax, 0      ; eax = 0
    mov ax, [a]     ; ax = a
    mov cl, 16
    rol eax, cl     ; move a into 16-31 bits from eax
    mov ax, bx      ; move bx into eax
    
    mov [c], eax    ; put result into c



    push dword 0 
    call [exit] 