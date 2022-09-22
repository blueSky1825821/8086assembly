assume cs:code
;code、a、b、start都是标号，表示内存单元的地址, 无 ":" 代码段 数据段都可
code segment
      ;a、b后没有':'，同时描述内存地址和单元长度的标号
      ;mov ax,b -> mov ax,cs:[8]
      ;mov b,2 -> mov word ptr cs:[8],2
      ;inc b -> inc word ptr cs:[8]
      a     db   1,2,3,4,5,6,7,8
      b     dw   0
      start:mov  si, 0
            mov  cx,8
      ;a 描述了地址 code:0，以后的内存单元都是字节单元
      s:    mov  al,a[si]
            mov  ah,0
      ;标号b 描述了code:8，以后的内存单元都是字单元
            add  b,ax
            inc  si
            loop s

            mov  ax,4c00h
            int  21h

code ends
        end start