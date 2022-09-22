assume cs:code

stack segment
              db 128 dup (0)
stack ends

data segment
             dw 0,0
data ends

code segment
        start:  mov   ax,stack
                mov   ss,ax
                mov   sp,128

                mov   ax,data
                mov   ds,ax

                mov   ax,0
                mov   es,ax

                cli
                push  es:[9*4]                             ;IP
                pop   ds:[0]
                push  es:[9*4+2]                           ;CS
                pop   ds:[2]                               ;将原来的int9中断例程的入口地址保存在ds:0、ds:2单元中
                sti

        ;这里使用cli和sti的原因是为了防止在设置新的中断例程入口的过程中防止
        ;键盘敲击或其他原因导致的外中断使CPU去其他地方执行程序导致错误
                cli                                        ;IF = 0屏蔽外中断
                mov   word ptr es:[9*4],offset int9
                mov   es:[9*4+2],cs                        ;在中断向量表中设置新的int9中断例程的入口地址
                sti                                        ;恢复外中断

                mov   ax,0b800h                            ;显存共32KB，占用了地址为B8000H-BFFFFH的内存空间
                mov   es,ax
                mov   ah,'a'

        s:      mov   es:[160*13+40*2],ah
                call  delay
                inc   ah
                cmp   ah,'z'
                jna   s                                    ;（低于等于==不高于）判断CF=1且ZF=1

                mov   ax,0
                mov   es,ax

                cli
                push  ds:[0]
                pop   es:[9*4]
                push  ds:[2]
                pop   es:[9*4+2]                           ;将中断向量表中int9中断例程的入口恢复为原来的地址
                sti

                mov   ax,4c00h
                int   21h

        delay:  push  ax
                push  dx
                mov   dx,10h                               ;循环100000h次,读者可以根据自己机器的速度调整循环次数
                mov   ax,0                                 ;s1连续执行
        s1:     sub   ax,1
                sbb   dx,0                                 ;借位减法
                cmp   ax,0
                jne   s1
                cmp   dx,0
                jne   s1
                pop   dx
                pop   ax
                ret

        ;int 指令执行过程：
        ; 1、取中断类型码n(模拟中断指令忽略此步骤)
        ; 2、标志寄存器入栈
        ; 3、IF=0，TF=0
        ; 4、CS、IP入栈，(IP)=((ds)*16+0),(CS)=((ds)*16+2)
        ; 5、(IP)=(n*4),(CS)=(n*4+2)

        ; 4 5 等同于call dword ptr ds:[0]
        ;  -以下为新的int9中断例程--
        int9:   push  ax
                push  bx
                push  es
                in    al,60h                               ;键盘处理端口，读入一个字节
        ;---步骤2 start---
                pushf                                      ;标志寄存器入栈
        ;---步骤2 end---

        ;---步骤3 start---
                pushf
                pop   bx
                and   bh,11111100b                         ;IF和TF为标志寄存器的第9位和第8位
                push  bx
                popf                                       ;IF=0，TF=0
        ;---步骤3 end---

        ;---步骤4 5 start---
                call  dword ptr ds:[0]                     ;CS、IP入栈，(IP)=((ds)*16+0),(CS)=((ds)*16+2);对int指令进行模拟,调用原来的int9中断例程
        ;---步骤4 5 end---
                cmp   al,1                                 ;扫描码 01 Esc判断
                jne   int9ret
                mov   ax,0b800h
                mov   es,ax
                inc   byte ptr es:[160*13+40*2+1]          ;将字符的属性值加1,改变颜色,无进位

        int9ret:pop   es
                pop   bx
                pop   ax
                iret
code ends
end start