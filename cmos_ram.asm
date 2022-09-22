;编程，读取CMOS RAM的 2号单元的内容
assume cs:code
code segment
    start:
          mov al,2
          out 70H,al      ;将2送入端口70H
          in  al,71H      ;从端口71H读出2号单元的内容
        
          mov ax,4c00H
          int 21H
code ends
end start