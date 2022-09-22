assume cs:codesg,ds:datasg,ss:stacksg
;正确的寄存器组合方式
;mov ax,[bx]
;mov ax,[si]
;mov ax,[di]
;mov ax,[bp]
;mov ax,[bx+si]
;mov ax,[bx+di]
;mov ax,[bp+si]
;mov ax,[bp+di]
;mov ax,[bx+si+idata]
;mov ax,[bx+di+idata]
;mov ax,[bp+si+idata]
;mov ax,[bp+di+idata]
;下面的指令是错误的:
;mov ax,[bx+bp]
;mov ax,[si+di]
;(3)  只要在[]中使用寄存器bp,而指令中没有显性地给出段地址,段地址就默认在
;SS 中。比如下面的指令。
;mov ax,[bp] 含义:(ax)=((ss)*16+(bp))
;mov ax,[bp+idata] 含义:(ax)=((ss)*16+(bp)+idata)
;mov ax,[bp+si] 含义:(ax)=((ss)*16+(bp)+(si))
;mov ax,[bp+si+idata] 含义:(ax)=((ss)*16+(bp)+(si)+idata)

datasg segment
           db 'ibm             '
           db 'dec             '
           db 'dos             '
           db 'vax             '
datasg ends
stacksg segment                   ;定义一个段,用来做栈段,容量为16个字节
            dw 0,0,0,0,0,0,0,0
stacksg ends
codesg segment
    start: mov  ax,stacksg
           mov  ss,ax
           mov  sp,16
           mov  ax,datasg
           mov  ds,ax
           mov  bx,0
           mov  cx,4
    s0:    push cx              ;将外层循环的cx值压栈，暂存的数据一般使用栈
           mov  si,0
           mov  cx,3            ;cx设置为内层循环的次数
    s:     mov  al,[bx+si]      ;(al) = ((ds)*16+(bx)+(si))
           and  al,11011111b
           mov  [bx+si],al
           inc  si
           loop s
           add  bx,16
           pop  cx              ;从栈顶弹出原cx的值,恢复cx
           loop s0              ;外层循环的loop指令将cx中的计数值减1
           mov  ax,4c00H
           int  21H
codesg ends
end start