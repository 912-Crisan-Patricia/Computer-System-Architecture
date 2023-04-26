bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    a db -11h
    b dw 1122h
    c dd 11223344h
    d dq 1122334455667788h
segment code use32 class=code
start:;(b + b + d) - (c + a)

    
    mov ax, [b]     ;ax = b
    cwde            ;ax -> eax = b
    mov ebx,eax     ;ebx = b
    
    add eax,ebx     ;eax = b + b
    cdq             ;eax -> edx:eax = b + b
    
    mov ebx, [d]
    mov ecx, [d+4]  ;ecx:ebx= d
    
    add ebx,eax
    adc ecx,edx     ;ecx:ebx = b + b + d
    
    mov edx,[c]     ;edx = c
    
    mov al,[a]      ;al = a
    cbw             ;al -> ax
    cwde            ;ax -> eax = a
    
    add eax,edx     ;eax = a + c
    cdq             ;eax -> edx:eax
    
    sub ebx,eax
    sbb ecx,edx     ;ecx:ebx = (b + b + d) - (c + a)
    


    push dword 0 
    call [exit] 
