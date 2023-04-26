bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    s DD 12345678h, 1A2C3C4Dh, 98FCDC76h
    len EQU ($-s)/4
    d times len db 0                        ; where we store the resulting array
    lend DD 0                               ; the length of the result
    digits times 3 db 0                     ; auxiliary array used to store decimal digits. We have at most 3 digits converting byte to decimal
    lendigits DD 0                          ; length of this auxiliary array


segment code use32 class=code
start:
    ;A list of doublewords is given. Obtain the list made out of the low bytes of the high words of each 
    ;doubleword from the given list with the property that these bytes are palindromes in base 10.
    ;s DD 12345678h, 1A2C3C4Dh, 98FCDC76h
    ;d DB 2Ch, FCh.
        mov ECX, len
        mov ESI, s
        mov EDI, d
        cld 
        main_loop:
            lodsd                           ; EAX <- Next dword from s
            shr EAX, 16                     ; We move the higher part of EAX into AX, so EAX = 0000:AX
            mov AH, 0                       ; to get only the low part. AL is the byte we work with
            
            push ESI                        ; We push ESI, ECX and EDI to the stack beacuse
            push ECX                        ; we use these registers to convert from base 16 to base 10
            push EDI                        ; and to check if the number is palindrome
            
            
            ; ------- CONVERTING TO BASE 10 -----------
            push EAX                        ; we keep a copy of the byte we check
            mov EDI, digits
            second_loop:
                mov BL, 10
                div BL                      ; AL = AX / 10, AH = AX % 10
                
                mov DL, AL                  ; DL = AX / 10. We need this for the next loop
                mov AL, AH                  ; AL = AX mod 10. This is the digit we must be store in memory
                
                stosb                       ; to next value in digits we store current digit, AL
                mov AL, DL
                mov AH, 0                   ; AX = initial number / 10
                
                inc dword [lendigits] 
                
                cmp AL, 0
                jz stop_second_loop         ;  if AL is 0, we must stop dividing
                
                jmp second_loop             ; if AL is not 0, we get the next digit

            stop_second_loop:
            
            pop EAX                         ; AL = byte we got the digits of
                                            ; In digits we have our number in decimal. We must check now if it is palindrome
            ;----------palindrome-----------
            mov ESI, digits
            mov EDI, digits
            add EDI, [lendigits]
            dec EDI                         ;  ESI <- beginning of digits, EDI <- end of digits, digits + lendigits - 1
            mov ECX, [lendigits]            ; number of digits
            shr ECX, 1                      ; we divide the number of digits in 2, because we do not need to check all digits for palindromity
            
            cld
            palindrom_loop:
                cmpsb                       ; compare pair of digits that should be the same
                jne not_palindrom           ; if they are not equal, stop checking
                sub EDI, 2                  ; EDI became EDI + 1, but we need it to be the previous digit, EDI - 1
                
                loop palindrom_loop
                
            pop EDI                         ; EDI <- d
            stosb                           ; we store our current byte (AL) in result array, d
            jmp was_palindrom
            
            not_palindrom:
                pop EDI                     ; EDI <- d
            
            was_palindrom:
            
            pop ECX 
            pop ESI                         ; ESI <- position in original string
            
            mov dword [lendigits], 0        ; we reset the count of number of digits
            loop main_loop                  ; exit(0)

    


    push dword 0 
    call [exit]