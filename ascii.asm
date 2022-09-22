assume cs:code,ds:data
;ascii 使用 '...'指明数据是以字符的形式给出，将转化为ASCII

data segment
    ;db 'unIX 相当于“db 75H,6EH,49H,58H",“u"、"n"、"1"、“x”的ASCII码分别为75H、6EH、49H、58H;
         db 'unIX'
    ;db foRK” 相当于“db 66H, 6FH, 52H, 4BH",“f"“o""R"“K”的ASCII码分别为66H、6FH、52H、4BH;
         db 'foRK'
data ends
code segment
    ;mov al,a” 相当于 “moval,61H”,“a”的ASCII码为61H;
    start:mov al,'a'
    ;mov bl,b” 相当于 6
    ;mov al,62H”, “b”的ASCII码为62H。

          mov bl,'b'
          mov ax,4c00h
          int 21h
code ends
end start