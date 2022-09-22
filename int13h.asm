;BIOS 提供的访问磁盘的中断例程为int 13h。读取0面O道1扇区的内容到0:200的程序

assume cs:code
code segment
      ;编程:将当前屏幕的内容保存在磁盘上。
      ;分析:1屏的内容占4000个字节,需要8个扇区,用O面0道的1~8扇区存储显存中的内容
      start:mov ax,0b800h
            mov es,ax
            mov bx,0           ;es:bx指向接收从扇区读入、写入数据的内存区

            mov al,1           ;读取的扇区数
            mov ch,0           ;磁道号
            mov cl,1           ;扇区号
            mov dl,0           ;驱动器号 软驱从0开始,0:软驱A，1:软驱B；硬盘从80h开始，80h:硬盘C，81h:硬盘D
            mov dh,0           ;磁头号(对于软盘即面号，因为一个面用一个磁头来读写)
            mov ah,3           ;int 13h的功能号(2表示读取扇区 3表示写扇区)
            int 13h            ;操作成功(ah)=0,(al)=读入的扇区数;操作失败(ah)=出错代码
      
          
            mov ax,4c00h
            int 21h

      read: mov ax,0
            mov es,ax          ;es:bx指向接收从扇区读入、写入数据的内存区
            mov bx,200h        ;es:bx 指向接收从扇区读入数据的内存区
            mov al,1           ;读取的扇区数
            mov ch,0           ;磁道号
            mov cl,1           ;扇区号
            mov dl,0           ;驱动器号 软驱从0开始,0:软驱A，1:软驱B；硬盘从80h开始，80h:硬盘C，81h:硬盘D
            mov dh,0           ;磁头号(对于软盘即面号，因为一个面用一个磁头来读写)
            mov ah,2           ;int 13h的功能号(2表示读取扇区 3表示写扇区)
            int 13h            ;操作成功(ah)=0,(al)=读入的扇区数;操作失败(ah)=出错代码

      write:mov ax,0
            mov es,ax
            mov bx,200h        ;es:bx 指向接收从扇区读入数据的内存区
            mov al,1           ;读取的扇区数
            mov ch,0           ;磁道号
            mov cl,1           ;扇区号
            mov dl,0           ;驱动器号 软驱从0开始,0:软驱A，1:软驱B；硬盘从80h开始，80h:硬盘C，81h:硬盘D
            mov dh,0           ;磁头号(对于软盘即面号，因为一个面用一个磁头来读写)
            mov ah,3           ;int 13h的功能号(2表示读取扇区 3表示写扇区)
            int 13h            ;操作成功(ah)=0,(al)=读入的扇区数;操作失败(ah)=出错代码






code ends
        end start