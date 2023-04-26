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
    nume_fisier db "lab8.txt", 0           ; file name
    mod_acces db "r", 0 
    descriptor dd -1                   ; the variable in which the descriptor is saved 
    nr_caract_citite dd 0
    len equ 100
    buffer resb len
    ascii resb 256
    format db "The uppercase letter with the highest frequency is %c. The frequency of the letter %c is %d. ", 0


segment code use32 class=code
start:  
    ;A text file is given. Read the content of the file, determine the uppercase letter with
    ;the highest frequency and display the letter along with its frequency on the screen. 
    ;The name of text file is defined in the data segment.
    push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2                      ; clean the parameters on the stack
                                             
        cmp eax, 0                          ;we verify if the function fopen opened the file
        je final
                          
        mov [descriptor], eax               ;save the descritor in the file                              
        repeta:                             ; we take 100 characters each time from the file and we transfer them in the buffer
            push dword [descriptor]
            push dword len
            push dword 1                    ; for string =1 , byte=1, word =2, dword=4
            push dword buffer
            call[fread]
            add esp, 4 * 4
            
            
            mov ecx, eax                    ; we count the number of characters in order to go through the buffer with the loop
            jecxz frecventa
            
                                            ; we go throudh the buffer
            mov esi, buffer                 ; we transfer the buffer in esi
            mov edi, ascii                  ; transfer in ascii code in edi
            cld                             ; go in string from left to right
            parcurgere:
                mov eax, 0
                lodsb                       ; transfer in al the first character from the buffer
                cmp al, 'A'
                jb continua
                cmp al, 'Z'
                ja continua
                inc dword [edi + eax]       ;  count the appearance of upper case letter that is in al
                continua:
            loop parcurgere
        jmp repeta                          ; read the next 100 characters
        
                                            ;  determine the upper case letter with the highest frequescy
        frecventa:
        push dword [descriptor]
        call [fclose]
        add esp, 4 * 1
        
                                            ;begin determination of frequency
        mov bl, 0                           ; initialize maximum number od apparitions with 0
        mov ecx, 255                        ; initialize ecx with number of characters in ascii table
        mov esi, ascii                      ; in esi se transfera sirul ascii(in care se cauta frecventele) transfer in esi ascii string (in which we look for frequency)
        
                                            ; search for the upper case letter with the biggest number of apparitions
        aparitii:
            lodsb                           ; trasnfer in al the frequency of the character in ascii
            cmp al, bl                      ; check if the frequency in al is higher than the old maximum number of occurrences 
            jb urmatorul                    ; if the frequency in al is lower, move to the next frequency
            mov bl, al                      ; the frequency from al is saved in bl, if it is higher
            mov eax, esi                    ; the value reached in esi is saved in eax
            sub eax, edi                    ; the element is searched for in the ascii code table (+1) (edi points to the beginning of the ascii string)
            mov edx, eax                    ; the value of eax is transferred to edx, i.e. the character with the maximum number of occurrences (+1)
            dec edx                         ; subtract 1 to get the character we are looking for
            urmatorul:
        loop aparitii
         
        
                                            ; the calculated result is displayed
        mov al, bl                          ; is transferred to the maximum frequency saved in bl
        cbw                                 ; convert to word
        cwde                                ; convert to dword
        push dword eax                      ; frequency
        push dword edx                      ; character
        push dword edx
        push dword format
        call [printf]
        add esp, 4 * 3
        
    final:


    push dword 0 
    call [exit]     