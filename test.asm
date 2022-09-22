assume cs:code
code segment
      start:
      ;       mov   ax, 0
      ;       push  ax
      ;       popf
      ;       mov   al, 0feh
      ;       add   al, 02h
      ;       pushf
      ;       pop   ax
      ;       and   al, 11000101B
      ;       and   ah, 00001000B

      ;       mov   ax,6
      ;       call  ax
      ;       inc   ax
      ;       mov   bp,sp
      ;       add   ax,[bp]     


      ;       mov   ax,2000h
      ;       mov   ss,ax
      ;       mov   sp,10h                  ;安排2000:0000~2000:000F 为栈空间,初始化栈顶, debug时和上一个指令一起执行
      ;       mov   ax,3123h
      ;       push  ax
      ;       mov   ax,3366h
      ;       push  ax                      ;在栈中压入两个数据

      ;       mov   ax,2
      ;       mov   bx,1
      ;       sub   bx,ax
      ;       adc   ax,1
      ; ;除法溢出
      ;       mov   ax,1000h
      ;       mov   bh,1
      ;       div   bh



      table dw    sub1

            mov   bx,0
      set:  push  bx
            cmp   ah,3                    ;判断功能号是否大于3
            mov   bl,ah
            mov   bh,0
            add   bx,bx                   ;根据ah中的功能号计算对应子程序在table表中的偏移
            call  word ptr table[bx]      ;table表的偏移可以找到对应的字符串的首地址

      sub1: push  bx
            push  cx
            push  es
            mov   bx,0b800h
            mov   es,bx
            mov   bx,0
            mov   cx,2000

            mov   ax,4c00h
            int   21h

code ends
        end start