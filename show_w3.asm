; 8086实模式 中断例程装载程序
; 中断号 7ch
; 装载位置 0:200h
; 比较w2 w3的区别，一个用int 10h,一个用显示器设置

assume cs:code
data segment
         db "welcome to masm! ",0
data ends
code segment
    start:     
               mov  ax,cs
               mov  ds,ax
               mov  si,offset handler                        ; ds:si指向中断例程的代码

               mov  ax,0
               mov  es,ax
               mov  di,200h                                  ; es:di指向中断例程装载位置
               mov  cx,offset handlerend - offset handler    ; 中断例程长度
               cld
               rep  movsb                                    ; 串传输

    ; 设置 7ch 号中断向量
               mov  ax,0
               mov  es,ax
               mov  word ptr es:[7ch*4],200h
               mov  word ptr es:[7ch*4+2],0

               mov  dh,10
               mov  dl,10
               mov  cl,2
               mov  ax,data
               mov  ds,ax
               mov  si,0
               int  7ch
               mov  ax,4c00h
               int  21h

    handler:   
    ; 注意！下文中断例程装载程序，只提供 handler 标号的部分，即，
    ; 中断处理程序开始 与 中断处理程序结束 包裹的部分

    ; 中断处理程序开始
    ; 显示0结尾的字符串
    ; dh 行号、dl 列号、cl 颜色、ds:si指向字符串首
               push si
               push es
               push di
               push ax
               push dx
               push cx

               mov  ax,0b800h                                ; 显存开始位置
               mov  es,ax
               mov  al,dh
               mov  dh,160
               mul  dh                                       ; ax=行号*160
               mov  dh,0
               add  dx,dx                                    ; dx=列号*2
               add  ax,dx
               mov  di,ax                                    ; di=行号*160+列号*2

    s:         
               mov  al,[si]
               cmp  al,0
               je   ok
               mov  ah,cl
               mov  es:[di],ax
               add  di,2
               inc  si
               jmp  s

    ok:        
               pop  cx
               pop  dx
               pop  ax
               pop  di
               pop  es
               pop  si
               iret
    ; 中断处理程序结束
    handlerend:
               nop

code ends
end start