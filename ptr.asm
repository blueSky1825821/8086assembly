assume cs:code
data segment
         dw 8 dup (0)
data ends
code segment
    start:mov  ax,data
          mov  ss,ax
          mov  sp,16
          mov  word ptr ss:[0],offset s
          mov  ss:[2],cs
          ;相当于执行 push CS,push IP,jmp dword ptr,两次push,sp-4=0cH存放的是IP，IP指向nop
          call dword ptr ss:[0]
          nop
    s:    mov  ax,offset s
          sub  ax,ss:[0cH]
          mov  bx,cs
          sub  bx,ss:[0eH]
          mov  ax, 4c00h
          int  21h
code ends
end start