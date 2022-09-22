;编程,接收用户的键盘输入
;输入"r",将屏幕上的字符设置为红色
;输入"g",将屏幕上的字符设置为绿色
;输入"b",将屏幕上的字符设置为蓝色.
assume cs:code

code segment
    ;读取缓冲区,如果缓冲区没有,则等待用户按下键盘
    start:mov  ah,0
          int  16h
    ;调用16h中断例程的0号功能从键盘缓冲区读取数据，如果为空则循环等待
    ;IF始终为零，即没有设置IF=1的指令，则不会处理int 9 中断，也即缓冲区永远不会有数据放入，就造成了int 16h 的死循环检测。显然不允许这样的事发生，所以一定有设置IF=1的指令。
          mov  ah,1
          cmp  al,'r'
          je   red
          cmp  al,'g'
          je   green
          cmp  al,'b'
          je   blue

          jmp  short sret
    
    ;00000100显示红色
    red:  shl  ah,1
    ;00000010显示绿色
    green:shl  ah,1
    ;00000001显示蓝色
    blue: 
          ;显存共32KB，占用了地址为B8000H-BFFFFH的内存空间
          mov  bx,0b800h
          mov  es,bx
          mov  bx,1
          mov  cx,2000
    s:    and  byte ptr es:[bx],11111000b
          or   es:[bx],ah
          add  bx,2
          loop s
    
    sret: mov  ax,4c00h
          int  21h

code ends
end start