;在屏幕中间显示80个“!”
assume cs:code
code segment
    start:mov  ax,cs
          mov  ds,ax
          mov  si,offset lp
          mov  ax,0
          mov  es,ax
          mov  di,200h
          mov  cx,offset lpend-offset lp
          cld
          rep  movsb
          mov  ax,0
          mov  es,ax
          mov  word ptr es:[7ch*4],200h
          mov  word ptr es:[7ch*4+2],0
               

          mov  ax,0b800h
          mov  es,ax
          mov  di,160*12
          mov  bx,offset s-offset se        ;设置从标号se到标号s的转移位移
          mov  cx,80
    s:    mov  byte ptr es:[di],'!'
          add  di,2
          int  7ch                          ;如果(cx)≠0,转移到标号s处
    se:   nop

          mov  ax,4c00h
          int  21h

    ;中断程序，调用另外一个方法时,ss:sp 已经存放了 push cs，push ip，cs指向s段地址(短位移)，ip指向se的偏移地址
    lp:   push bp
          mov  bp,sp                        ;;将sp给bp也就是将栈顶指针给bp
          dec  cx                           ;;然后cx减1就是为了模拟loop指令
          jcxz lpret                        ;如果cx为0了就直接跳到lpret处，然后pop出数据返回
          add  [bp+2],bx                    ;首先我们要明白栈中的数据从栈顶到栈底分别为bp的原先的值，se的偏移地址，然后是cs寄存器的值装的也就是s的段地址，然后再是标志寄存器的值，所以bp+2的值就是se的偏移地址加上bx就为s的偏移地址了

    lpret:pop  bp                           ;pop出数据
          iret                              ;做的就是pop IP,pop CS popf

    lpend:nop

code ends
end start