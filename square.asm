;功能:求一word型数据的平方。
;参数:(ax)要计算的数据。
;返回值:dx、ax中存放结果的高16位和低16位。
;应用举例:求2*3456^2。

;分析一下,我们要做以下3部分工作。
;(1) 编写实现求平方功能的程序;
;(2) 安装程序,将其安装在0:200 处;
;(3) 设置中断向量表,将程序的入口地址保存在7ch表项中,使其成为中断7ch的中断例程。

assume cs:code
code segment
    start: mov  ax,cs
           mov  ds,ax
           mov  si,offset sqr                  ;设置ds:si指向源地址
           mov  ax,0
           mov  es,ax
           mov  di,200h                        ;设置es:di指向目的地址
           mov  cx,offset sqrend-offset sqr    ;设置cx为传输长度
           cld                                 ;设置传输方向为正
           rep  movsb
           mov  ax,0
           mov  es,ax
           mov  word ptr es:[7ch*4],200h
           mov  word ptr es:[7ch*4+2],0

           mov  ax,3456                        ;(ax)=3456
           int  7ch                            ;调用中断7ch的中断例程,计算ax中的数据的平方
           add  ax,ax
           adc  dx,dx                          ;dx:ax存放结果,将结果乘以2

           mov  ax,4c00h
           int  21h
    sqr:   mul  ax
    ;相当于 pop IP,pop CS,popf
           iret
    sqrend:nop
code ends
end start