DATAS SEGMENT
    ;此处输入数据段代码
    string1		db 'HELLO'
    len_str1	equ	$-string1
    
    waittime	db	?
    sav_dh		db	?	
    sav_dl		db	?
    flag1		db	0
    flag2		db	0
		
DATAS ENDS

STACKS SEGMENT	STACK
    ;此处输入堆栈段代码
    dw	100 dup (0)
STACKS ENDS



CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV		AX,DATAS
    MOV 	DS,AX
    ;此处输入代码段代码
return:    
    call	go_right
    jmp		return

_out:	
    MOV AH,4CH
    INT 21H    
 ;******************************/******************************/   
    
go_right	proc
    
    mov		dl,0	;定标,列
    mov		dh,0	;定标,行
    jmp		to1
go: 
	cmp	flag1,1 
	jz	dec_dh
	inc	dh
	;inc	dh
	jmp	to_dl
dec_dh:
	dec	dh
	;dec	dh
to_dl:
	cmp	flag2,1 
	jz	dec_dl
   	inc	dl
	;inc	dl
	jmp	save
dec_dl:
	dec	dl
	;dec	dl
save:
    	mov	sav_dl,dl 
	mov	sav_dh,dh    
to1:
    call	display	
    ;int		1ch	;调用中断以等待????
    call	delay
comment /*
    mov		ah,0
    int		1ah
    cmp		dl,90
    jnb		to1_
    add		dl,10
    mov		waittime,dl
    jmp		wait1
go1:	jmp	go
to1_:
	sub	dl,90
	inc	dl	
	mov	waittime,dl    
wait1:     
    mov		ah,0
    int		1ah
    cmp		waittime,dl
    jnz		wait1
*/
      
    mov		ah,1
    int		16h	;读缓冲区的字符????
    cmp		al,27
    jz		_out  
 comment /*  
    mov		ah,0bh
    int		21h
    inc		al
    jz		_out 
*/
    mov		dh,sav_dh 
	cmp	flag1,1
	jz	_flag1
    cmp		dh,24
    jb		next1
	mov	flag1,1
_flag1:
    cmp		dh,0
    ja		next1
	mov	flag1,0
next1:
        mov	dl,sav_dl 
	cmp	flag2,1
	jz	_flag2  
   
    cmp		dl,75     
    jb		go
	mov	flag2,1
_flag2:

	cmp	dl,0
    	ja	go
	mov	flag2,0
	jmp	go

    ret     
go_right	endp 

;******************************/******************************/ 
   
display		proc
	push	ax
	push	dx
	push	cx
	push	bx	

	mov		al,3
    mov		ah,0
    int		10h
    mov		bp,seg string1
    mov		es,bp
    mov		bp,offset string1
    mov		cx,5;len_str1
    mov		dh,sav_dh	;定标,行  
    mov		dl,sav_dl	;定标,列
    
    mov		bl,00011110b	;蓝底黄字
    mov		al,0
    mov		ah,13h    
    int		10h
    
    pop		bx
    pop 	cx
    pop		dx
    pop		ax
    
    ret    	   
display		endp

delay proc near         ;延时子程序
     push cx
     push dx
     mov dx,50000
 d11:mov cx,10000
 d12:loop d12
     dec dx
     jnz d11
     pop dx
     pop cx
     ret
delay endp

;******************************/******************************/

CODES ENDS
    END START
    
    
    