;(1) 在输入的同时需要显示这个字符串;
;(2) 一般在输入回车符后,字符串输入结束;
;(3) 能够删除已经输入的字符。

;说明
;① 调用int 16h读取键盘输入;
;② 如果是字符,进入字符栈,显示字符栈中的所有字符;继续执行①;
;③ 如果是退格键,从字符栈中弹出一个字符,显示字符栈中的所有字符;继续执行①;
;④ 如果是Enter键,向字符栈中压入0,返回。
;参数说明: (ah)=功能号,0表示入栈,1表示出栈,2表示显示;
;ds:si指向字符栈空间;
;对于0号功能:(a1)=入栈字符;
;对于1号功能:(al)=返回的字符;
;对于2号功能:(dh)、(dl)字符串在屏幕上显示的行、列位置。
assume cs:code

code segment

    getstr:   push ax
    getstrs:  mov  ah,0
              int  16h
              cmp  al,20h
              jb   nochar                       ;ASCII码小于20h,说明不是字符
              mov  ah,0
              call charstack                    ;字符入栈
              mov  ah,2
              call charstack                    ;显示栈中的字符
              jmp  getstrs
    nochar:   cmp  ah,0eh                       ;退格键的扫描码
              je   backspace
              cmp  ah,1ch                       ;Enter 键的扫描码
              je   enter
              jmp  getstrs

    backspace:mov  ah,1
              call charstack                    ;字符出栈
              mov  ah,2
              call charstack                    ;显示栈中的字符
              jmp  getstrs
    enter:    mov  al,0
              mov  ah,0
              call charstack                    ;0入栈
              mov  ah,2
              call charstack                    ;显示栈中的字符
              pop  ax
              ret

    charstack:jmp  short charstart
    table     dw   charpush,charpop,charshow
    top       dw   0                            ;栈顶
    charstart:push bx
              push dx
              push di
              push es
              cmp  ah,2
              ja   sret
              mov  bl,ah
              mov  bh,0
              add  bx,bx
              jmp  word ptr table[bx];跳转具体table
    charpush: mov  bx,top
              mov  [si][bx],al
              inc  top
              jmp  sret
    charpop:  cmp  top,0
              je   sret
              dec  top
              mov  bx,top
              mov  al,[si][bx]
              jmp  sret
    charshow: mov  bx,0b800h
              mov  es,bx
              mov  al,160
              mov  ah,0
              mul  dh
              mov  di,ax
              add  dl,dl
              mov  dh,0
              add  di,dx
              mov  bx,0
    charshows:cmp  bx,top
              jne  noempty
              mov  byte ptr es:[di],' '
              jmp  sret
    noempty:  mov  al,[si][bx]
              mov  es:[di],al
              mov  byte ptr es:[di+2],' '
              inc  bx
              add  di,2
              jmp  charshows

    sret:     pop  es
              pop  di
              pop  dx
              pop  bx
              ret


    s_end:    mov  ax,4c00h
              int  21h

code ends
end getstr