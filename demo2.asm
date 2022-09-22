section .data
    ;(数据段)放置变量
    ;字符串常量
    string DB 'Hello World!'
    ;字符串长度，$表示string_len的偏移地址-string的偏移地址，就是string长度
    string_len DB $ - string

section .bss
    ;bss段（也是存放变量，不过不知道与data有何区别）

section .text
    ;(代码段)放置代码

;定义入口函数
global _MAIN

_MAIN:
	;rax、rdi、rsi、rdx分别存放系统调用号、类型(输出)、字符串地址、字符串长度
    MOV rax,0x2000004
    MOV rdi,1
    MOV rsi,string
    MOV rdx,string_len
    syscall
    ;退出，rax、rdi分别存放系统调用号、类型(退出)
    mov rax,0x2000001
    mov rdi,0
    syscall

