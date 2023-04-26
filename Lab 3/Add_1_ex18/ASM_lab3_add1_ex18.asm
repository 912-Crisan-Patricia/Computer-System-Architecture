bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
 
    a db 11h
    b dw 1122h
    c dd 11223344h
    d dq 1122334455667788h
    
    
segment code use32 class=code
start: ;(d + d)- a - b - c

    mov eax, [d]
    mov edx, [d+4]  ;edx:eax = d
    
    
    mov ebx, [d]
    mov ecx, [d+4]  ;ecx:ebx = d
    
    add eax,ebx
    adc edx,ecx     ;edx:eax = d + d
    
    mov ebx, 0
    mov bl, [a]     ;ebx = a 
    mov ecx, 0      ;ecx:ebx = a
    
    sub eax,ebx
    sbb edx,ecx     ;edx:eax = d + d - a
    
    mov ebx, 0
    mov bx, [b]     ;ebx = b 
    mov ecx, 0      ;ecx:ebx = b
    
    sub eax,ebx
    sbb edx,ecx     ;edx:eax = d + d - a - b
    
    mov ecx, 0
    mov ebx, [c]      ;ecx:ebx = c
    
    sub eax,ebx
    sbb edx,ecx     ;edx:eax = d + d - a - b - c
    
    
    
    push dword 0 
    call [exit] 
