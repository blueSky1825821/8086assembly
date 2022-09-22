;编写并安装int 7ch中断例程, 功能为显示
;一个用0结束的字符串, 中断例程安装在0:200处
;参数: (dh)=行号, (dl)=列号, (cl)=颜色, ds:si指向字符串首地址
assume cs:code
data segment
         db "welcome to masm!",0
data ends
code segment

    start:      mov  ax,cs
                mov  ds,ax
                mov  si,offset show_str
                mov  ax,0
                mov  es,ax
                mov  di,200h
                mov  cx,offset show_strend-offset show_str
                cld
                rep  movsb

                mov  ax,0
                mov  es,ax
                mov  word ptr es:[7ch*4],200h
                mov  word ptr es:[7ch*4+2],0
          
                mov  dh,13                                    ;dh中放行号
                mov  dl,50                                    ;dl中放列号
                mov  cl,2                                     ;cl 颜色
                mov  ax,data
                mov  ds,ax
                mov  si,0
                int  7ch

                mov  ax,4c00h
                int  21h

    show_str:   
                mov  bl,cl                                    ;颜色
                mov  bh,0                                     ;第O页
          
    s:          mov  ah,2                                     ;置光标
    ;dh行号, dl列号，此处主要是为了置光标，避免和下面的int 10h 中ah冲突
                int  10h

                mov  ch,0
                mov  cl,ds:[si]
                jcxz ok
                mov  ah,9                                     ;在光标位置显示字符
                mov  al,cl                                    ;字符
	; mov bh,0		;第0页
                mov  cx,1                                     ;字符重复个数
                inc  si
                inc  dl                                       ;dl中放列号
                int  10h
                jmp  short s
    ok:         iret                                          ;做的就是pop IP,pop CS popf
    show_strend:nop

code ends
end start