bits 32 
global start


; declare external functions needed by our program
extern exit, fprintf, fopen, fclose, printf, fread ,fwrite              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll                                           ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                                                                 ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fprintf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll 
import fread msvcrt.dll    
import fwrite msvcrt.dll 

segment data use32 class=data
    fisierinput db "test_input.txt",0
    fisieroutput db "test_output.txt",0
    modread db 'r',0
    modwrite db 'w',0
    descriptor dd -1
    descriptor2 dd -1
    buffer db 0
    len equ 200
    sir db 0
    ok db 0
    lensenteces dd 0
    string db 4, 5, 6, 7
    cuvant dd 0

segment code use32 class=code
start:
    ;A file containing only sentences (a sentence is a string ending with the '-' character).
    ;Write an assembly program that reads the given file and writes in a different file the 2nd to last word from each sentence followed by the number of words from each sentence.
    ;The names of both files are located in the data segment.
    
    ;output file: the will the good 4
    
    push dword modread
    push dword fisierinput
    call [fopen]
    add esp, 4*2                ;open file 
    
    mov [descriptor],eax
    cmp eax,0
    je final                 ;if error occured during fopen jump to final
    
    push dword modwrite
    push dword fisieroutput
    call [fopen]
    add esp, 4*2                ;open the output file for writing
    
    
    
    mov [descriptor2],eax
    cmp eax, 0
    je final
        
    
    repeta:
        push dword [descriptor]
        push dword 1
        push dword 1  
        push dword sir
        call [fread]  
        add esp, 4*4             ;read 200 characters from input file one byte and places it in sir
        
        ;mov ecx, eax
        ;jecxz final              ;if empty file, jump to final 
        ;push eax 
        
        ;std                     ;df =1 so we go from left to right
        ;mov esi,sir
        ;loop2:
            ;mov bx,0
            ;lodsb               ;takes byte from esi and loads it in al
            ;cmp al, '-'
            ;jne caseword
            ;cmp al, ' '
            ;je casespace
            ;caseline:           
                ;mov byte [ok],0               ;case in which byte = "-" , we should reset the number of words and 
            ;casespace:
                ;jmp endcase              ;case in which byte = " " , we should reset loop 2
                              
                     
            ;caseword:
                ;add bx,[ok]                ;case in which byte is part of a sentence
                ;add bx,1 
                ;cmp bx,2
                ;je storebyte
            ;storebyte:           ;if ok = 2 , it means the word is second to last and we should add it to output string
                
            ;endcase:
                ;loop loop2
                
        push dword [descriptor2]
        push dword 1
        push dword 1
        push dword string
        call [fwrite]
        add esp,4*4             ;write word
        
        cmp eax,0
        je error                ;case in which the word could not store
    loop repeta
    
    
    
    cmp eax,0
    je error
    
    error:
    push dword modread
    push dword fisieroutput
    call [fclose]
    add esp, 4*2                ;close file 
    final:
    
    push dword 0
    call [exit] 