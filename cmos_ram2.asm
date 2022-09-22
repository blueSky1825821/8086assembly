;向CMOS RAM的2号单元写入0
assume cs:code
code segment
    start:
          mov al,2
          out 70h,al      ;要访问的CMOS RAM单元地址为 (al)=2
          mov al,0
          out 71H,al      ;写入数据到选定的CMOS RAM单元地址

          mov ax,4c00H
          int 21H
code ends
end start
