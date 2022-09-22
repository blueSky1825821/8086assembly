assume cs:code
;检测点 16.1
code segment
    a     dw   1,2,3,4,5,6,7,8
    b     dd   0
    ;奇怪 c dw a,b 编译出错，等价于 d dw offset a,offset b
    d     dw   a,b
    ;等价于 e dd offset a,seg a,offset b,seg b
    ;seg 取得某一标号的段地址，编译后d 076C:0 可看出结果
    e     dd   a,b
    
    start:mov  si,0
          mov  cx,8
    s:    mov  ax,a[si]
    ;等价于 mov al,cs:0[si] => mov al,cs:[si+0] => mov al,cs:[si]
    ;程序中包括 add 和 adc 两种加法指令，add 用于累加 a 处的数据、adc 用于处理进位数据。
    ;b 为双字单元，使用 b[0] 存储相加内容、b[2] 存储进位内容
          add  word ptr b[0],ax
          adc  word ptr b[2],0
          add  si,2
          loop s

          mov  ax,4c00h
          int  21h
code ends
end start