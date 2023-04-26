bits 32 
global start
 
; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll    
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf


segment data use32 class=data
    a dd 15
    b dd 0
    format db "%d",0
    message db "a+a/b=%d",0


segment code use32 class=code
start:  
    ;A natural number a (a: dword, defined in the data segment) is given. 
    ;Read a natural number b from the keyboard and calculate: a + a/b. 
    ;Display the result of this operation. The values will be displayed in decimal format (base 10) with sign.
   
    push dword b                ; push the value where I put the read number
    push dword format           ; push its format
    call [scanf]                ; read the number from keyboard
    add ESP, 4*2                ;clear the stack
    
    mov EAX, [a]                ; put the value of a in eax
    cdq                         ; make eax quadraword
    idiv dword[b]               ; divide eax quadra to value of b, and becomes again dword
    mov EDI, EAX                ; edi=eax
    add EDI, [a]                ; edi=eax+a
    
    push dword EDI              ; push the value to be printed
    push dword message          ; push its format
    call [printf]               ; print the message and the value of the expression
    add ESP, 4*2                ; clear the stack


    push dword 0 
    call [exit] 