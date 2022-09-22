;屏幕中间显示当前的月份
; ① 将从CMOS RAM的8号单元中读出的一个字节,分为两个表示BCD码值的数据。
; ② 显示(ah)+30h和(al)+30h对应的ASCII码字符。
;RAM 单元内容 秒:0 分:2 时:4 日:7 月:8 年:9
assume cs:code
code segment
    start:mov al,8                              ;从CMOS RAM的8号单元读取数据
          out 70h,al                            ;往70h端口写入一个字节
          in  al,71h                            ;往71h端口读入一个字节

          mov ah,al                             ;一个字节表示2个BCD码
          mov cl,4
          shr ah,cl                             ;高4位表示十位
          and al,00001111b                      ;低4位表示个位

          add ah,30h
          add al,30h
          mov bx,0b800h
          mov es,bx
          mov byte ptr es:[160*13+40*2],ah      ;显示月份的十位数码
          mov byte ptr es:[160*13+40*2+2],al    ;接着显示月份的个位数码

          mov ax,4c00h
          int 21h

code ends
end start