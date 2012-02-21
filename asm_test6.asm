DATAS SEGMENT
    ;此处输入数据段代码
_menu db 'please take a choice for what _type you want to show your system time !',0ah,0dh 
      db '1,first _type : left _and up !',0ah,0dh
      db '2,second _type : right _and up !',0ah,0dh
      db '3,third _type : left _and up !',0ah,0dh
      db '4,forth _type : right _and down !',0ah,0dh
      db '5,exit!',0ah,0dh
      db '	Choice: $'
error  db '!!!  error !!!  $'    
_replay    db 'continue? (y/n)',0ah,0dh,'$'
bye       db '      Press any buttom for goodbye !!!','$'    
_dl		db	? 
for_dl	db	0
for_dh	db	0   
data	db	'   YEAR	MONTH DATA','$'

time	db	'TIME','$'
div_num	dw	10000,1000,100,10,1
dec_buf	db	5 dup(' ')
	db	'$'
flag	db	1     
DATAS ENDS

STACKS SEGMENT	STACK
    ;此处输入堆栈段代码
    dw	100 dup (0)
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
	call	menu
display_1:    
    mov		for_dh,0
    mov		for_dl,10
    call	display
display_2:    
    mov		for_dh,0
    mov		for_dl,60
    call	display
display_3:    
    mov		for_dh,21
    mov		for_dl,10
    call	display    
display_4:    
    mov		for_dh,21
    mov		for_dl,60
    call	display
    
    
_out:
		mov		ah,1
    	int		21h
		call	crlf
		lea		dx,_replay
    	mov		ah,09
    	int		21h	
    	mov		ah,1
    	int		21h
    	call	crlf
    	cmp		al,'n'
    	jnz	    start		
exit:
	lea		dx,bye
    mov		ah,09
    int		21h
	mov		ah,1
    int		21h		    
    MOV AH,4CH
    INT 21H 
    
menu	proc	near
		
Restrat:    
	lea 	dx,_menu
    mov		ah,09
    int		21h
    mov 	ah,1
    int 	21h
    call	crlf
    call	clear_screen
    
    cmp 	al,31h
    jz		display_1
    cmp		al,32h
    jz 		display_2
    cmp 	al,33h
    jz 		display_3
    cmp 	al,34h
    jz 		display_4
    cmp 	al,35h
    jz 		exit
    call	crlf
    lea 	dx,error
    mov 	ah,09
    int 	21h 
    call	crlf 
    jmp 	Restrat 
	call crlf


  		ret
menu	endp
       
display		proc	near 
play:   
    mov		dh,for_dh	;定标
    mov		dl,for_dl
    mov		ah,2
    int		10h
    
    lea		dx,data
    mov		ah,9
    int		21h
        
    mov		dh,for_dh	;定标
    add		dh,1
    mov		dl,for_dl
    add		dl,2
    mov		ah,2
    int		10h	
    
    mov		ah,2ah
    int		21h 
    mov		_dl,dl   
    mov		bx,cx
    call	print_d
    mov		dl,'/'
    mov		ah,2
    int		21h
    mov		bl,dh
    mov		bh,0
    call	print_d
    mov		dl,'/'
    mov		ah,2
    int		21h
    mov		dl,_dl
    mov		bl,dl
    mov		bh,0
    call	print_d
    
        
  
    mov		dh,for_dh	;定标
    add		dh,2
    mov		dl,for_dl
    sub		dl,10
    mov		ah,2
    int		10h	
    
    lea		dx,time
    mov		ah,9
    int		21h
        
    mov		ah,2ch
    int		21h
    mov		_dl,dl
    mov		bl,ch
    mov		bh,0
    call	print_d
    mov		dl,':'
    mov		ah,2
    int		21h
    mov		bl,cl
    mov		bh,0
    call	print_d
    mov		dl,':'
    mov		ah,2
    int		21h
    mov		bl,dh
    mov		bh,0
    call	print_d
    mov		dl,':'
    mov		ah,2
    int		21h
    mov		dl,_dl
    mov		bl,dl
    mov		bh,0
    call	print_d
    
    mov		ah,0bh
    int		21h
    inc		al
    jz		_out
    jmp		play
    
    ret
display		endp    

  
    
  ;----------------------------------  
print_d	proc
	push	ax
	push	cx
	push	dx
	push	si
	push	di
	mov	flag,1
	mov	ax,bx
	mov	dx,0
	mov	cx,5
	lea	si,dec_buf
	lea	di,div_num
lp1:
	mov	bx,[di]
	div	bx
	
	cmp	al,0
	jne	s
	cmp	flag,1
	jne	s
	mov	al,' '
	jmp	j
s:	mov	flag,0
	add	al,30h
j:	mov	[si],al
	mov	ax,dx
	mov	dx,0
	inc	si
	add	di,2
	loop	lp1
	lea	dx,dec_buf
	mov	ah,9
	int	21h
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	ax
	ret		
print_d endp

    ;-------------------------------   
  crlf               proc         near   ;换行
  						push	ax
  						push	dx
                       
                        mov           dl,0dh   
                        mov           ah,2   
                        int           21h   
                        mov           dl,0ah   
                        mov           ah,2   
                        int           21h 
                        pop		dx
                        pop		ax  
                        ret   
  crlf               endp   
  ;----------------------------------
clear_screen	proc	near
			push	ax
			push	bx
			push	cx
			push	dx
			
			mov		ah,6
			mov		al,0
			mov		bh,7
			mov		ch,0
			mov		cl,0
			mov		dh,24
			mov		dl,79
			int		10h
			
			mov		dx,0
			mov		ah,2
			int		10h
			
			pop		dx
			pop		cx
			pop		bx
			pop		ax
	ret
clear_screen	endp  
  ;-------------------------------      
CODES ENDS
    END START

