bits 32 
global start


; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll    
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf      

segment data use32 class=data
    a dd 10
    b dd 8
    result dq 0
    message db "%d * %d = %d", 0
segment code use32 class=code
start:
    ;Two natural numbers a and b (a, b: dword, defined in the data segment) are 
    ;given. Calculate their product and display the result in the following format: 
    ;"<a> * <b> = <result>". Example: "2 * 4 = 8"
    ;The values will be displayed in decimal format (base 10) with sign.
    
    mov eax, [a]
    imul dword [b]
    
    mov [result], eax
    mov [result + 4], edx
    
    push dword [result]
    push dword [b]
    push dword [a]
    push dword message
    call [printf]
    add esp, 4*4
    
    
    push dword 0 
    call [exit]