assume cs:codesg,ds:datasg,ds:tablesg,ss:stacksg

stacksg segment
            db 16 dup (0)    ;16字节的内存作为栈段
stacksg ends

datasg segment
           db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
           db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
           db '1993','1994','1995'
    ;以上是表示21年的21个字符串，起始地址datasg:0

           dd 16,22,382,1356,2390,8000,16000,24486,50056,97479,140417,197514
           dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司收入的21个dword型数据，起始地址datasg:84

           dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
           dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word新数据，起始地址datasg:168
    ;数据段总大小210字节
datasg ends

tablesg segment
            db 21 dup ('year summ ne ?? ')
    ;|0123456789abcdef|
    ;|year summ ne ?? |
    ; 0    5 7  a  d
tablesg ends

codesg segment

    start: mov  ax,stacksg
           mov  ss,ax
           mov  ax,datasg
           mov  ds,ax
           mov  ax,tablesg
           mov  es,ax

           mov  bp,0                    ;用于table表寻址，每次循环自增16
           mov  si,0                    ;用于数据中summ寻址，每次循环自增4
           mov  di,0                    ;用于数据中ne寻址，每次循环自增2
           mov  cx,21
    s:     push cx
           mov  bx,si                   ;用于数据中year寻址
           push si
           mov  si,0
           mov  cx,4
    s0:    mov  al,ds:[bx+si]
           mov  es:[bp+si],al
           inc  si
           loop s0
           pop  si
    ;以上循环实现将年份信息存入table表中

           mov  ax,ds:[di+168]
           mov  es:[bp+0ah],ax          ;table表存入ne
    ;C语言描述中的T[i].ne = nes[i]

           mov  ax,ds:[si+84]           ;双字型数据的低16位
           mov  dx,ds:[si+86]           ;双字型数据的高16位
           mov  es:[bp+5],ax
           mov  es:[bp+7],dx            ;table表存入summ
    ;C语言描述中的T[i].summ = summs[i]

           div  word ptr es:[bp+0ah]
           mov  es:[bp+0dh],ax          ;除法计算，table表存入ave
    ;C语言描述中的T[i].ave = summs[i] / nes[i];

           add  bp,16
           add  si,4
           add  di,2
           pop  cx
           loop s

           mov  ax,4c00h
           int  21h

codesg ends

end start