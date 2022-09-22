assume cs:code
;模拟不出来，必须要DOSbox操作
code segment
    start:
          mov ah,1        ;0清屏，1设置前景色，2设置背景色，3表示向上滚动一行
          mov al,5        ;传送颜色值,(al)∈{0,1,2,3,4,5,6,7}
          int 7ch
          mov ax,4c00h
          int 21h
code ends
end start		