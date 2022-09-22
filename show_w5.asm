;分别在第2/4/6/8行显示4句英文诗，补全程序
assume cs:code
code segment
    s1:   db   'Good,better,best,','$'
    s2:   db   'Never let it rest','$'
    s3:   db   'Till good is better,','$'
    s4:   db   'And better,best.','$'
    s:    dw   offset s1,offset s2,offset s3,offset s4
    row:  db   2,4,6,8

    start:mov  ax,cs
          mov  ds,ax
          mov  bx,offset s
          mov  si,offset row
          mov  cx,4
    ok:   mov  bh,0                                       ;第0页
          mov  dh,ds:[si]                                 ;设置行
          mov  dl,0                                       ;设置列
          mov  ah,2                                       ;置光标
          int  10h

          mov  dx,ds:[bx]
          mov  ah,9                                       ;在光标位置显示字符
          int  21h
          
          add  bx, 2
          inc  si
          loop ok

          mov  ax,4c00h
          int  21h
code ends
end start
