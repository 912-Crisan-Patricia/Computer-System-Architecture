bits 32 
global start


; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll    
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf
 

segment data use32 class=data
    a dd 0
    b dd 0
    k dd 10
    format db "%d",0
    message db "(a+b)*k=%d",0

    

segment code use32 class=code
start: 
    ;Two numbers a and b are given. Compute the expression value: (a+b)*k, 
    ;where k is a constant value defined in data segment. Display the expression value (in base 10).
    
    
    push dword a                ; push the value where I put the read number
    push dword format           ; push its format
    call [scanf]                ; read the number from keyboard
    add ESP, 4*2                ; clear the stack
    
    push dword b                ; push the value where I put the read number
    push dword format           ; push its format
    call [scanf]                ; read the number from keyboard
    add ESP, 4*2                ; clear the stack
    
    mov EDI, [a]                ; edi=a
    add EDI, [b]                ;edi=a+b
    imul EDI, dword[k]          ; edi=(a+b)*k
    
    push dword EDI              ; push the value to be printed
    push dword message          ; push its format
    call [printf]               ; print the message and the value of the expression
    add ESP, 4*2                ;clear the stack

    push dword 0 
    call [exit] 