;参数:(cx)循环次数,(bx)=位移
;显示80个"!"

assume cs:code
code segment
    start:      
                mov  ax,cs
                mov  ds,ax
                mov  si,offset show_str                         ; ds:si指向中断例程的代码

                mov  ax,0
                mov  es,ax
                mov  di,200h                                    ; es:di指向中断例程装载位置
                mov  cx,offset show_strend - offset show_str    ; 中断例程长度
                cld
                rep  movsb                                      ; 串传输

    ; 设置 7ch 号中断向量
                mov  ax,0
                mov  es,ax
                mov  word ptr es:[7ch*4],200h
                mov  word ptr es:[7ch*4+2],0
    
    
                mov  ax,0b800h
                mov  es,ax
                mov  di,160*12
                mov  bx,offset s-offset se                      ;设置从标号se到标号s的转移位移
                mov  cx,80
    s:          mov  byte ptr es:[di],'!'
                add  di,2
                int  7ch                                        ;如果(cx)≠0,转移到标号s处
    se:         nop

                mov  ax,4c00h
                int  21h


    show_str:   
                push bp
                mov  bp,sp
                dec  cx
                jcxz ok
                add  ss:[bp+2],bx                               ;参考character5.asm
    ok:         pop  bp
                iret                                            ;做的就是pop IP,pop CS popf
    show_strend:nop
code ends
end start