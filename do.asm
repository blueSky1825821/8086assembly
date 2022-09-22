;(1) 编写可以显示“overflow!”的中断处理程序: do0;
;(2) 将do0送入内存0000:0200 处; 
;(3) 将do0的入口地址0000:0200 存储在中断向量表0号表项中。
assume cs:code
data segment
         
data ends
code segment
    start:   mov  ax,cs
             mov  ds,ax
             mov  si,offset do0                  ;设置ds:si指向源地址
             mov  ax,0
             mov  es,ax
             mov  di,200h                        ;设置es:di指向目的地址
             mov  cx,offset do0end-offset do0    ;设置cx为传输长度
             cld                                 ;设置传输方向为正
             rep  movsb
    ;设置中断向量表 0000:0200H~02FFH 空闲空间，放入中断向量表0:除法错误
             mov  ax,0
             mov  es,ax
             mov  word ptr es:[0*4],200h
             mov  word ptr es:[0*4 + 2],0

    ;除法溢出 同 int  0
             mov  ax,1000h
             mov  bh,1
             div  bh

             mov  ax,4c00h
             int  21h
    
    ;数据放在此处，主要为了避免该中断程序执行完后就被别的信息覆盖了，导致下次执行中断程序时有误
    do0:     jmp  short do0start
    ;do0存在0000:0200h的位置，jmp short占2个字节，则 db在0000:0202h
             db   "overflow!"

    do0start:mov  ax,cs
             mov  ds,ax
             mov  si,202h                        ;设置ds:si指向字符串
    ;8086CPU显存是0B8000~0BFFFF一共有32KB的显存空间
    ;即8页4K每页，每页25行，每行可现实80个字，每个字占2字节，高8位是字符低8位是颜色属性
             mov  ax,0b800h
             mov  es,ax
             mov  di,13*160+36*2                 ;设置es:di指向显存空间的中间位置
             mov  cx,9                           ;设置cx为字符串长度
    s:       mov  al,[si]
             mov  es:[di],al
             inc  si
             add  di,2
             loop s
             
             mov  ax,4c00h
             int  21h
    do0end:  nop
code ends
end start