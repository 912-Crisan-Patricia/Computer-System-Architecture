bits 32 
global start


extern exit 
import exit msvcrt.dll  

segment data use32 class=data
    s db 'a', 'A', 'b', 'B', '2', '%', 'x', 'M'
    l equ $-s
    d times l db 0 

segment code use32 class=code
start: ; A character string S is given. Obtain the string D that contains all capital letters of the string S.
    
    mov esi, 0                   ; esi=0
	mov edi, 0                   ; edi=0    
	Repeta:
        mov al, [s+esi]          ; al gets the value of each element of the string
        cmp al, 'Z'              ; compare al to Z
        ja not_capital           ; if al is grater than Z jumps to label
        cmp al, 'A'              ; compare al to A
        jb not_capital           ; if al is less than A jumps to label
        mov [d+edi], al          ; moves al to the result on the corresponding position
        inc edi                  ; increment edi by 1
        not_capital:
        inc esi                  ; increment esi by 1
        cmp esi, l               ; compare esi to l
        jb Repeta                ; if esi is less than l repeats the loop


    
    push dword 0 
    call [exit] 