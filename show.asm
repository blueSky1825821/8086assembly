assume cs:code
stack segment
              db 128 dup (0)
stack ends
;(1) 用ah寄存器传递功能号:0表示清屏,1表示设置前景色,2表示设置背景色,3表示向上滚动一行;
;(2) 对于1、2号功能,用al传送颜色值,(al)∈{0,1,2,3,4,5,6,7}.
code segment
        start:       
                     mov  ax,cs
                     mov  ds,ax
                     mov  si,offset setscreen
                     mov  ax,0
                     mov  es,ax
                     mov  di,200h
                     mov  cx,offset setscreenend -offset setscreen
                     cld
                     rep  movsb

        ;设置中断向量表
                     mov  ax,0
                     mov  es,ax
                     mov  word ptr es:[7ch*4],200h
                     mov  word ptr es:[7ch*4+2],0

                     mov  ah,3                                            ;0清屏，1设置前景色，2设置背景色，3表示向上滚动一行
                     mov  al,5                                            ;传送颜色值,(al)∈{0,1,2,3,4,5,6,7}
                     int  7ch

                     mov  ax,4c00h
                     int  21h
        ;表示下一条地址从偏移地址200H开始，和安装后的偏移地址相同，若没有org 200H，中断例程安装后，标号代表的地址改变了，和之前编译器编译的有所区别
        ;在汇编语言源程序的开始通常都用一条ORG伪指令来实现规定程序的起始地址。如果不用ORG规定则汇编得到的目标程序将从0000H开始
                     org  200h
        setscreen:   
                     jmp  short set
        table        dw   sub1,sub2,sub3,sub4

                     mov  ax,4c00h
                     int  21h

        set:         push bx
                     cmp  ah,3                                            ;判断功能号是否大于3
                     ja   sret
                     mov  bl,ah
                     mov  bh,0
                     add  bx,bx                                           ;根据ah中的功能号计算对应子程序在table表中的偏移
                     call word ptr table[bx]

        sret:        pop  bx
                     ret



        ;(1) 清屏:将显存中当前屏幕中的字符设为空格符;
        sub1:        push bx
                     push cx
                     push es
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,0
                     mov  cx,2000
        subls:       mov  byte ptr es:[bx],' '
                     add  bx,2
                     loop subls
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        ;(2) 设置前景色:设置显存中当前屏幕中处于奇地址的属性字节的第0、1、2位;
        sub2:        push bx
                     push cx
                     push es
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,1
                     mov  cx,2000
        sub2s:       and  byte ptr es:[bx],11111000b
                     or   es:[bx],al
                     add  bx,2
                     loop sub2s
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        ;(3) 设置背景色:设置显存中当前屏幕中处于奇地址的属性字节的第4、5、6位;
        sub3:        push bx
                     push cx
                     push es
                     mov  cl,4
                     shl  al,cl
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,1
                     mov  cx,2000
        sub3s:       and  byte ptr es:[bx],10001111b
                     or   es:[bx],al
                     add  bx,2
                     loop sub3s
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        ;(4) 向上滚动一行:依次将第n+l行的内容复制到第n行处;最后一行为空。
        sub4:        push cx
                     push si
                     push di
                     push es
                     push ds
                     mov  si,0b800h
                     mov  es,si
                     mov  ds,si
                     mov  si,160                                          ;ds:si指向第n+1行
                     mov  di,0                                            ;es:di指向第n行
                     cld
                     mov  cx,24                                           ;共复制24行
        sub4s:       push cx
                     mov  cx,160
                     rep  movsb                                           ;复制
                     pop  cx
                     loop sub4s
                     mov  cx,80
                     mov  si,0
        sub4sl:      mov  byte ptr [160*24+si],' '                          ;最后一行清空
                     add  si,2
                     loop sub4sl

                     pop  ds
                     pop  es
                     pop  di
                     pop  si
                     pop  cx
                     ret

        setscreenend:
                     nop

code ends
        end start