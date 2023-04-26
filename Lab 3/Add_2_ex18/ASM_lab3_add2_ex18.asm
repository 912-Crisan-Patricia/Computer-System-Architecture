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
start:; (d - b) - a - (b - c)

    mov ebx, [d]
    mov ecx, [d+4]      ;ecx:ebx = d
    
    mov ax, [b]         ;ax = b
    cwde                ;ax -> eax
    cdq                 ;eax -> edx:eax = b
    
    sub ebx, eax
    sbb ecx, edx        ;ecx:ebx = d - b
    
    mov al, [a]         ;al = a
    cbw                 ;ax = a
    cwde                ;ax -> eax = a
    cdq                 ;edx:eax = a
    
    sub ebx, eax
    sbb ecx, edx        ;ecx:ebx = (d - b) - a
    
    mov ax,[b]          ;ax = b
    cwde                ;ax -> eax
    
    mov edx,[c]         ;edx = c
    
    sub eax,edx
    cdq                 ;eax -> edx:eax = b - c
    
    sub ebx,eax
    sbb ecx,edx         ;ecx:ebx = (d - b) - a - (b - c)
    
    

    push dword 0 
    call [exit] 
