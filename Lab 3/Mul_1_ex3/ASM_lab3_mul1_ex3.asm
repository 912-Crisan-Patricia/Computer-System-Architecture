bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
     
    a db 11h
    b db 22h
    c dd 11223344h
    d db 33h
    x dq 1122334455667788h

segment code use32 class=code
start:;(8 - a * b * 100 + c) / d + x - unsigned
 
    mov al, [a]         ;al = a
    mul byte [b]        ;ax = a * b
    mov bx, 100
    mul bx              ;dx:ax = a * b * 100
    
    push dx
    push ax
    pop eax             ;dx:ax -> eax = a * b * 100

    
    mov ebx, [c]        ;ebx = c
    sub ebx, eax        ;ebx = c - a * b * 100
             
    add ebx, 8          ;ebx = (8 - a * b * 100 + c)
    
    mov al, [d]
    mov ah, 0           ;al -> ax = d
    
    push word 0
    push ax
    pop  ecx            ;ax -> ecx = d
    
    mov eax, ebx
    mov edx, 0          ;ebx -> edx:eax
    
    div ecx             ;eax = (8 - a * b * 100 + c) / d
    
    mov edx, 0          ;eax -> edx:eax = (8 - a * b * 100 + c) / d
    
    mov ebx, [x]
    mov ecx, [x+4]      ;ecx:ebx = x
    
    add eax, ebx
    adc edx, ecx        ;edx:eax = result
    
    push dword 0 
    call [exit] 
