assume cs:codesg

datasg segment
db"Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment
    start:  
            mov  ax,datasg
            mov  ds,ax
            mov  si,0
            call letterc
	
            mov  ax,4c00h
            int  21h
	
    letterc:
            push si
            push ax
	
    check:  
            mov  al,ds:[si]
            cmp  al,0
            je   over            ;结束
            cmp  al,'a'
            jb   skip
            cmp  al,'z'
            ja   skip
            and  al,11011111b
            mov  ds:[si],al
    skip:   
            inc  si
            jmp  short check
	
    over:   
            pop  ax
            pop  si
            ret
codesg ends
end start