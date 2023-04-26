bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    s dw -256,256h
    s1 db 7, 33, 55, 19, 46
    L1 equ $-s1
    s2 db 33, 21, 7, 13, 27, 19, 55, 1, 46
    L2 equ $-s2
    d times L2 db 0
    

segment code use32 class=code
start:
    ;Two byte strings s1 and s2 are given. Build the byte string d such that, for every byte s2[i] in s2, 
    ;d[i] contains either the position of byte s2[i] in s1, either the value of 0.
    ;pos:1 2 3 4 5
    ;s1: 7, 33, 55, 19, 46
    ;s2: 33, 21, 7, 13, 27, 19, 55, 1, 46 
    ;d: 2,  0, 1, 0, 0, 4, 3, 0, 5
    
    
    mov ECX, L2                     ; we put the length of the first string, so the first loop will be executed for each number from the string
    mov ESI, s2                     ; In the source register we place the address of s2
    mov EDI, s1                     ; In the destination register we place the addres of s1
    jecxz end_loop
    CLD                             ; We set the direction flag to 0, so we could go through the string from left to right.
    first_loop: 
        push ECX                    ; we save the value of ECX by pushing it to the stack     
        mov ECX, L1                 ; we put the length of the second string
            jecxz end_of_the_second_loop 
            lodsb                   ;  AL <-- current element from s2, and ESI is increased by one.
            second_loop:
                scasb               ; We compare the value from AL with the value from <ES:EDI> by making a fictive subtraction which won't affect their value ; AL - <ES:EDI>
                                    ;If the DF = 0, EDI will be increased by one, but we already know DF is 0 because we setted it's value before the start of the first loop
                je if_equal         ; If the difference is equal to 0, it means the numbers are equal so the ZF = 0 and we jump to if_equal:
                jmp not_equal       ; If they are not equal we jump to not_equal and we go to the next element from the string s1
                if_equal:
                    mov EBX, EDI    ; We put in EBX the value from EDI so we can modify EDI's value without changing it in the register
                    sub EBX, s1     ; Like that we obtain the position from the string s1 of the current number from the string s2
                    sub ESI, s2 
                    sub ESI, 1      ; Like that we obtain the corresponding position in the destination string 
                    mov [d+ESI],BL  ; We place the position from the string s1 in the destination string on the corresponding position
                    add ESI, s2 
                    add ESI, 1
                                    ;Like that we get back ESI to its initial value
                not_equal:
            loop second_loop
            mov EDI, s1             ; We have to place again the addres of s1 in EDI, because EDI was changed and we need to start over in all cases
            end_of_the_second_loop:
        pop ECX                     ; We take from the stack the previous value of ECX
        
    loop first_loop
    end_loop:


    
    push dword 0 
    call [exit] 