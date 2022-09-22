assume cs:code
;code、a、b、start都是标号，表示内存单元的地址
code segment
      ;a、b后没有':'，同时描述内存地址和单元长度的标号
      ;mov ax,b -> mov ax,cs:[8]
      ;mov b,2 -> mov word ptr cs:[8],2
      ;inc b -> inc word ptr cs:[8]
      ;db 8bits
      ;dw 2bytes
      ;dd 4bytes
      a     dw   1,2,3,4,5,6,7,65535
      b     dd   0
      start:mov  si, 0
            mov  cx,8
      ;a 描述了地址 code:0，以后的内存单元都是字单元
      s:    mov  ax,a[si]
      ;标号b 
            add  word ptr b[0],ax
            adc  word ptr b[2],0
            ;2 a[si] 表字单元的起始
            add  si,2
            loop s

            mov  ax,4c00h
            int  21h

code ends
        end start