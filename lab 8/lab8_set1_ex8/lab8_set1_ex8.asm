bits 32 
global start


; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll    
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf      

segment data use32 class=data
   a dd 10
   b dd 0
   message db "%d",0
   result dd 0

segment code use32 class=code
start:
    ;A natural number a (a: dword, defined in the data segment) is given. Read a    ;natural number b from the keyboard and calculate: a + a/b. Display the result of
    ;this operation. The values will be displayed in decimal format (base 10) with ;sign.
    
    
    
    push dword b      ;read b from keyboard
    push dword message
    call [scanf]
    add esp, 4*2
    
    mov edx,0
    mov eax ,[a]        ;eax= a
    div dword [b]       ;edx:eax = a/b
    
    adc eax, [a]        ;eax= a + a/b
    
    mov [result], eax
    
    
    push dword [result]
    push dword message
    call [printf]
    add esp,4*2         ;print result
    
    
    push dword 0 
    call [exit]
    