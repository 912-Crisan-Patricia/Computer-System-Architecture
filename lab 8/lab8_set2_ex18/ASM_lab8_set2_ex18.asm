bits 32 
global start


; declare external functions needed by our program
extern exit, fprintf, fopen, fclose, printf, fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fprintf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll 
import fread msvcrt.dll    

segment data use32 class=data
    nume_fisier db "lab8_2.txt", 0           ; file name
    mod_acces db "r",0                      
    descriptor dd 0                         ; the variable in which the descriptor is saved
    len equ 100
    buffer resb len
    result db 0
    ok db 0                                 ; variable that will change to 1 once finding a character and then 0 to "." " "
    format db "The number of words found is %d",0
    
    

segment code use32 class=code
start:  ;A text file is given. The text contains letters, spaces and points.
        ;Read the content of the file, determine the number of words and display the result on the screen. 
        ;(A word is a sequence of characters separated by space or point)
    
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2                      ; clean the parameters on the stack
                                             
        cmp eax, 0                          ;we verify if the function fopen opened the file
        je final                     
        mov [descriptor], eax 
        
            repeta:                             ; we take 100 characters each time from the file and we transfer them in the buffer
            push dword [descriptor]
            push dword len
            push dword 1                    ; for string =1 , byte=1, word =2, dword=4
            push dword buffer
            call[fread]
            add esp, 4 * 4                  
            
            mov ecx, eax
            jecxz afisare
            mov esi, buffer
            cld                             ;clear df in order to go from left to right
            loop_1:
                lodsb                       ;get from esi >> al so that we can compare byte 
                cmp al, "."
                jz case.
                cmp al, " "                 
                jz case.                    ;if byte = "." or " " go to case.
                
                mov byte [ok],1             ;if byte character then change ok to 1
                jmp endcase.                ;this case presents 
                
                case.:                    ;when the character is . or " "
                    mov bl,[ok]             ;save ok in bl in order to copy value
                    cmp bl,0                ;if ok was 1 it means that the character found has a character before it so it wont count as word
                    je endcase.             ;if ok zero >> jumps to endcase
                    mov byte [ok],0         
                    add byte [result],1     ;increase word count in resut in the case which ok was 1 
                          
                endcase.:
            loop loop_1
       
    afisare:
        mov bl,[ok]
        cmp bl,0
        je label_2
        mov byte [ok],0
        add byte [result],1                 ;repeat case. in case we dont have " " or "." after the last word 
        label_2:
            mov eax,0
            mov al, [result]
            push dword eax
            push dword format
            call [printf]
            add esp, 4* 2                   ;prints result
    
    final:
    push dword 0 
    call [exit]     
