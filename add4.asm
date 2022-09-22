assume cs:code,ds:data
;检测点 16.2
;数据段
data segment
    a    db 1,2,3,4,5,6,7,8
    b    dw 0
    ;奇怪 c dw a,b 编译出错，等价于 d dw offset a,offset b
    d    dw a,b
    ;等价于 e dd offset a,seg a,offset b,seg b
    ;seg 取得某一标号的段地址
    e    dd a,b
data ends
code segment
    start:mov  ax,data
          mov  ds,ax
          mov  si,0
          mov  cx,8
    s:    mov  al,a[si]
    ;等价于 mov al,ds:0[si] => mov al,ds:[si+0] => mov al,ds:[si]
          mov  ah,0
          add  b,ax
          inc  si
          loop s

          mov  ax,4c00h
          int  21h
code ends
end start