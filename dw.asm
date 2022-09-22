assume cs:codesg
codesg segment
    ;定义字型数据，dw "define word"
           dw   0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
    ;程序加载后，将取得16个字的内存空间，存放这16个数据。在后面的程序中将这段空间当作栈来使用，开辟内存空间
           dw   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    start: mov  ax,cs
           mov  ss,ax
           mov  sp,30h                                             ;将设置栈顶ss:sp 指向cs:30
           mov  bx,0
           mov  cx,8
    S:     push cs:[bx]
           add  bx,2
           loop s                                                  ;以上将代码段0~15单元中的8个字型数据依次入栈
           mov  bx,0
           mov  cx,8
    s0:    pop  cs:[bx]
           add  bx,2
           loop s0                                                 ;以上依次出栈8个字型数据到代码段0~15单元中
           mov  ax,4c00h
           int  21h
codesg ends
end start ;指明程序的入口在start处