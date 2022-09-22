assume cs:code
;1000:0000
stack segment
	      db 16 dup (0)
stack ends

code segment
	      mov  ax,4c00h
	      int  21h

	start:mov  ax,stack
	      mov  ss,ax
	      mov  sp,16h
	      mov  ax, 1000h
	      push ax
	      mov  ax, 0
	      push ax
	      mov  bx,0
	      retf
code ends

end start
