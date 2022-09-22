assume cs:code, ds:data, ss:stack
 
data segment
         db 128 dup(0)
data ends
 
stack segment
          db 128 dup(0)
stack ends
 
code segment
 
    TIME_STYLE      db   'YY/MM/DD HH:MM:SS', 0
    TIME_CMOS       db   9,8,7,4,2,0               ;RAM 单元内容 秒:0 分:2 时:4 日:7 月:8 年:9
 
    start:          
                    mov  ax, stack
                    mov  ss, ax
                    mov  sp, 128
 
                    call init_reg
                    call show_clock
 
                    mov  ax, 4c00h
                    int  21h
 
 
    ;----------------------------
    show_clock:     
                    call show_time_style
    showTime:       
                    mov  si, OFFSET TIME_CMOS
                    mov  di, 160*10+30*2
                    mov  cx, 6
 
    showDate:       
                    mov  al, ds:[si]
                    out  70h, al
                    in   al, 71h
                    mov  ah, al
                    shr  ah, 1
                    shr  ah, 1
                    shr  ah, 1
                    shr  ah, 1
                    and  al, 00001111b
 
                    add  ah, 30h
                    add  al, 30h
 
                    mov  es:[di], ah
                    mov  es:[di+2], al
 
                    inc  si
                    add  di, 6
                    loop showDate
                    jmp  showTime                  ;控制一直显示
	
                    ret
 
    ;----------------------------
    init_reg:       
                    mov  bx, 0b800h
                    mov  es, bx
 
                    mov  bx, cs
                    mov  ds, bx
                    ret
    ;----------------------------
    show_string:    
                    push dx
                    push ds
                    push es
                    push si
                    push di
	
    showString:     
                    mov  dl, ds:[si]
                    cmp  dl, 0
                    je   showStringRet
                    mov  es:[di], dl
                    add  di, 2
                    inc  si
                    jmp  showString                ;先在固定位置显示 YY/MM/DD HH:MM:SS，然后一直在这个地方显示具体date，覆盖无用的字段，厉害
 
    showStringRet:  
                    pop  di
                    pop  si
                    pop  es
                    pop  ds
                    pop  dx
 
                    ret
 
	
    ;---------------------------
    show_time_style:
                    mov  si, OFFSET TIME_STYLE
                    mov  di, 160*10+30*2
 
                    call show_string
                    ret
code ends
end start