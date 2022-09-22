;masm 使用可显示
assume cs:code
code segment
         mov ah,2            ;置光标
         mov bh,0            ;第O页
         mov dh,5            ;dh中放行号
         mov dl,12           ;dl中放列号
         int 10h

         mov ah,9            ;在光标位置显示字符
         mov al,'a'          ;字符
         mov bl,11001100b    ;颜色属性
         mov bh,0            ;第O页
         mov cx,10           ;字符重复个数
         int 10h
    ;(ah)4ch表示调用第21h号中断例程的4ch号子程序,功能为程序返回,可以提供返回值作为参数。等价于
    ;mov ah,4ch ;程序返回
    ;mov al,0 ;返回值
         mov ax,4c00h
         int 21h
code ends
end