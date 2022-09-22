;功能：功能:在指定的位置，用指定的颜色，显示一个用0结束的字符串。
;参数：(dh)=行号(取值范围0 ~ 24)，(dl)=列号(取值范围0 ~ 79)，(cl)颜色，ds:si指向字符串首地址
;返回：无
;应用举例：在屏幕的8行3列，用绿色显示data段中的字符串
assume cs:code
data segment
         db 'welcome to masm!',0
data ends

code segment
    start:   mov  dh,8
             mov  dl,3
             mov  cl,2
             mov  ax,data
             mov  ds,ax
             mov  si,0
             call show_str

             mov  ax,4c00h
             int  21h

    show_str:mov  al,0ah
             mul  dh
             add  ax,0b800h
             mov  es,ax           ;获取具体行的段地址
             mov  bh,0
             mov  bl,dl
             add  bl,dl           ;es:bx定位地址显示字符
             mov  si,0
             mov  dl,cl           ;dl存储要显示的color

    s:       mov  cl,ds:[si]
             mov  ch,0
             jcxz ok              ;如果cx == 0退出循环
             mov  al,ds:[si]
             mov  es:[bx],al      ;设置字符
             mov  es:[bx+1],dl    ;设置color
             inc  si
             add  bx,2
             jmp  short s
    ok:      ret

code ends
end start