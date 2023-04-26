bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
     
    a db 11h
    b db 22h
    c dw 1122h
    e dd 11223344h
    x dq 1122334455667788h

segment code use32 class=code
start:;(a+b*c+2/c)/(2+a)+e+x

    
    mov al,[b]      ;al = b
    mov ah, 0       ;al -> ax = b
    mul word [c]    ;dx:ax = b * c
    
    push dx
    push ax         ;[ESP]1 = dx:ax = b * c
    
    mov dx, 0
    mov ax, 2       ;dx:ax = 2
    
    div word [c]    ;ax = 2/c
    mov cx, ax      ;cx = 2/c
    
    mov bl, [a]
    mov bh, 0       ;bl -> bx = a
    
    pop ax
    pop dx          ;dx:ax = +
    
    add ax, cx
    adc dx, 0       ;dx:ax = (b*c+2/c)
    
    add ax, bx
    adc dx, 0       ;dx:ax = (a+b*c+2/c)
    
    mov bl, [a]     
    mov bh, 0       ;bl -> bx = a
    add bx, 2       ;bx = a + 2
    
    div bx          ;ax = (a+b*c+2/c)/(2+a)
    
    push 0
    push ax
    pop eax         ;ax -> eax = (a+b*c+2/c)/(2+a)
    
    mov ecx, [e]
    
    add eax, ecx    ;eax = (a+b*c+2/c)/(2+a)+e
    
    mov edx, 0      ;eax -> edx:eax = (a+b*c+2/c)/(2+a)+e
    
    mov ebx, [x]
    mov ecx, [x+4]
    
    add eax, ebx
    adc edx, ecx    ;edx:eax = final result
    
        
    push dword 0 
    call [exit] 

