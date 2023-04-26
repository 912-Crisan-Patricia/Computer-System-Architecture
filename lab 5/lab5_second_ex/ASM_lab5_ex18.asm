bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    s db 1, 2, 4, 6, 10, 20, 25
    l equ $-s
    d times l-1 db 0 ; d trebuie D: 1, 2, 2, 4, 10, 5


segment code use32 class=code
start: ; A byte string S of length l is given. 
    ;Obtain the string D of length l-1 so that the elements of D represent the difference between every two consecutive elements of S

	mov ESI, 1              ; esi=1
	Repeta:
    	
        mov AL, [s+ESI]     ; al takes the values from 2nd element to the last from s
        mov BL, [s+ESI-1]   ; bl takes the values from first to the last but one from s
        sub AL, BL          ; al=al-bl
        mov [d+ESI], AL     ; mov al on the corresponding byte o the result
        inc ESI             ; increment esi by 1
        cmp ESI, l          ; compare esi to l in order to know when to finish the loop
        jb Repeta           ;repeat the instructions until esi=l




    push dword 0 
    call [exit] 