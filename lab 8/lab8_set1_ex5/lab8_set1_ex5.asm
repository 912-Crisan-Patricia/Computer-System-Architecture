bits 32 
global start


; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll    
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf      

segment data use32 class=data
    a dd 23
    b dd 10
    quo dd 0
    rem dd 0
    message dd "quotient = %d, remainder = %d",0

segment code use32 class=code
start:
    ;Two natural numbers a and b (a, b: dword, defined in the data 
    ;segment) are given. Calculate a/b and display the quotient and the 
    ;remainder in the following format: "Quotient = <quotient>, 
    ;remainder = <remainder>". Example: for a = 23, b = 10 it will 
    ;display: "Quotient = 2, remainder = 3".
    ;The values will be displayed in decimal format (base 10) with sign.
    
    mov edx,0
    mov eax,[a]
    div dword [b]
    
    mov [rem], dx
    mov [quo], ax
    
    push dword [rem]
    push dword [quo]
    push dword message
    call [printf]
    add esp, 4*3
    
    push dword 0 
    call [exit]