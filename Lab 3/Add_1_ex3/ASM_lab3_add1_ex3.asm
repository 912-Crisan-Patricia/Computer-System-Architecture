bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    
    a db 12h
    b dw 1234h
    c dd 12345678h
    d dq 1122334455667788h
segment code use32 class=code
start: ;(c + d) - (a + d) + b
    
    ;c -> edx:eax
    mov eax, [c]    ;eax = c
    mov edx, 0      ;eax -> edx:eax = c
    
    ;d -> ecx:ebx
    mov ebx, [d]
    mov ecx, [d+4]  ;ecx:ebx = d
    
    add eax, ebx    
    adc edx, ecx    ;edx:eax = c + d
    
    ;stack -> edx:eax
    push edx        ;[esp]1 = edx
    push eax        ;[esp]2 = eax
    
    mov eax, 0
    mov al, [a]     ;eax = a
    mov edx, 0      ;edx:eax = a
    
    add eax, ebx    
    adc edx, ecx    ;edx:eax = a + d
    
    pop ebx     
    pop ecx         ;ecx:ebx = c + d
    
    sub ebx,eax
    sbb ecx,edx     ;ecx:ebx = (c + d) - (a + d)
    
    mov eax, 0
    mov edx, 0
    mov ax, [b]     ; edx:eax = b
    
    add ebx,eax
    adc ecx,edx     ; ecx:ebx = (c + d) - (a + d) + b
    
    push dword 0 
    call [exit] 
