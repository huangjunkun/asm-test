stack	segment stack
	dw	40h dup(0)
stack	ends

data	segment
choice_for_num		db 'Please choice how many number^2(1~20) for matrix you want to have',0ah,0dh 
					db '	Number: $'
decoration		db '_and which mark in ASCII to decorate your matrix for nothing.: $'
decorated		db '	The mark you choiced is $'	
ok		db '	OK???(Y/N) $'				
_menu db 'please take a choice for what _type you want to have',0ah,0dh 
      db '1,first _type.',0ah,0dh
      db '2,second _type.',0ah,0dh
      db '3,third _type.',0ah,0dh
      db '4,forth _type.',0ah,0dh
      db '5,exit!',0ah,0dh
      db '	Choice: $'
error  db '!!!  error !!!  $'
do     db '      Press any buttom for continue !!!','$'
_replay    db 'continue? (y/n)',0ah,0dh,'$'
bye       db '      Press any buttom for goodbye !!!','$'
_i db ?
_j db ?
num	db ?
mark	db	20h
_k dw ?
div_num	dw	10000,1000,100,10,1
dec_buf	db	5 dup(' ')
	db	'$'
flag	db	1
data	ends

CODE SEGMENT
    assume	cs:code,ds:data,ss:stack
START:
    MOV AX,DATA
    MOV DS,AX
    ;此处输入代码段代码
    call	crlf
    lea 	dx,choice_for_num
    mov		ah,09
	int	21h

 			mov	bx,0   
newchar:      			
	mov           ah,1   
        int           21h   
 	cmp           al,0dh   
   	jz            _redecoration   
   	sub           al,30h   
      	jl            exit1   
        cmp           al,9d   
       	jg            exit1   
        cbw   
        xchg          ax,bx   
        mov           cx,10  
        mul           cx   
        xchg          ax,bx   
        add           bx,ax                 
  	jmp	newchar 

exit1:    
	call 	crlf   
	mov     dx,offset   error  
        mov     ah,9   
        int 	21h             ;如不是数字，则显示error.   
       	jmp  	start 
_redecoration : 
	cmp	bx,0
	jnz	next
	mov	bl,5
next:
    	mov	num,bl
    
redecoration:
	call	crlf
    lea 	dx,decoration
    mov		ah,09
    int		21h
    mov 	ah,1
    int 	21h
    sub		al,30h
    mov		mark,al
    call	crlf
    lea 	dx,decorated
    mov		ah,09
    int		21h
    mov		dl,mark
    mov 	ah,2
    int 	21h
    call	crlf
    lea 	dx,ok
    mov		ah,09
    int		21h
    mov 	ah,1
    int 	21h
    cmp		al,'n'
    jz	    redecoration
    call	crlf
    call	crlf
	call	display
	call	crlf
	lea 	dx,do
    mov		ah,09
    int		21h
	mov 	ah,1
    int 	21h
    call	crlf
    call	crlf
    
	call	menu 
	   
_start:
	jmp	start      	
toprint_1:	
	call	print_1
	call 	crlf
	call	replay
toprint_2:
	call	 print_2
	call 	crlf
	call	replay
toprint_3:	
	call 	print_3
	call 	crlf
	call	replay
toprint_4:
	call 	print_4
	call 	crlf
 	call	replay

toquit:
	call	quit 
	
    MOV AH,4CH
    INT 21H
    
;----------------------------------

menu	proc	near
		
Restrat:    
	lea 	dx,_menu
    mov		ah,09
    int		21h
    mov 	ah,1
    int 	21h
    call	crlf
    cmp 	al,31h
    jz		toprint_1
    cmp		al,32h
    jz 		toprint_2
    cmp 	al,33h
    jz 		toprint_3
    cmp 	al,34h
    jz 		toprint_4
    cmp 	al,35h
    jz 		toquit
    call	crlf
    lea 	dx,error
    mov 	ah,09
    int 	21h 
    call	crlf 
    jmp 	Restrat 
	call crlf


  		ret
menu	endp

;----------------------------------

replay	proc	near
		push	ax
		push	dx
		
		lea		dx,_replay
    	mov		ah,09
    	int		21h	
    	mov		ah,1
    	int		21h
    	call	crlf
    	cmp		al,'y'
    	jz	    _start		
		jmp		toquit
		pop		dx
		pop		ax

  		ret
replay	endp
;---------------------------------- 
display		proc	near

			mov	ax,data
			mov	ds,ax
			mov _k,0
			mov	al,num	
			mov _j,al
	
rep1:			
			mov	al,num	
			mov _i,al
rep2:    
    		inc _k
    		mov bx,_k	
    		call print_d		
			dec _i			
			jnz rep2
			call crlf		
			call crlf
			dec _j	
			jnz rep1
	ret
display		endp
;---------------------------------- 
    
print_1 proc	near

	mov _k,0	
	mov _i,1
	
rep3_1:	
	mov _j,1
rep4_1:
    
    mov ch,_i
	mov cl,_j	
	cmp ch,cl
	jb rep6_1     
    inc _k
    inc _j
    mov bx,_k	
    call print_d		
	jmp rep4_1
rep6_1:
	mov	bl,num	
	mov al,bl
	sub al,ch
	mov ch,0	
	mov cl,al
	cmp	cx,0
	ja	rep5_1
	jmp n	
rep5_1:
    inc _k
    call kge        
    loop rep5_1	  
n:    
	call crlf
	call crlf
	inc _i
	mov	bl,num
	inc	bl	
	mov al,bl	
	sub al,_i
	jnz rep3_1



ret
print_1 endp    

  ;----------------------------------
  
print_2 proc
	mov _k,0
	mov	bl,num	
	mov _i,bl

	
rep3_2:	mov _j,1
rep4_2:
    mov ch,_i
	mov cl,_j	
	cmp ch,cl
	jz rep6_2    
    inc _k
    call kge 
    inc _j	
	jmp rep4_2
rep6_2:	
	;mov	bl,num	;结果一样!
	;inc	bl
	mov al,num
	sub al,ch
	inc	al
	mov ch,0
	mov cl,al
	
rep5_2:
    inc _k
    mov bx,_k	
    call print_d    		
    loop rep5_2 	
      
    call crlf
	call crlf
	dec _i

	jnz rep3_2



ret
print_2 endp
  ;---------------------------------- 
  
print_3 proc
	mov _k,0
	mov	bl,num	
	mov _i,bl
	;mov cx,0
	
rep3_3:	mov _j,0
rep4_3:    
    inc _k
    mov bx,_k	
    call print_d		
	inc _j
	mov ch,_i
	mov cl,_j
	
	cmp ch,cl
	jnz rep4_3
	mov al,num
	sub al,ch
	mov ch,0
	mov cl,al
	jz rep6_3
	
rep5_3:
    call kge
    inc _k
    loop rep5_3 	
rep6_3:  
    call crlf
	call crlf
	dec _i
	jnz rep3_3



  ret
print_3 endp
  ;----------------------------------
  
print_4 proc
	mov _k,0	
	mov _i,1
	;mov cx,0
	
rep3_4:	mov _j,1
rep4_4:
    
    mov ch,_i
	mov cl,_j	
	cmp ch,cl
	jz rep6_4 
	inc _k
    call kge
    inc _j	
	;cmp _j,6	
	jmp rep4_4
rep6_4:	
	mov al,num
	inc	al
	sub al,cl
	mov ch,0	
	mov cl,al
	;dec cl	
rep5_4:
    inc _k
    inc _j
    mov bx,_k	
    call print_d 
    loop rep5_4	 
    call crlf
	;loop rep1
	call crlf
	mov	bl,num
	inc	bl
	inc _i		
	cmp _i,bl
	jne rep3_4



ret
print_4 endp
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
kge               proc         near   ;空格
                        push cx
                        push ax
                        push dx                      
                        mov cx,4
                       
             lp:        mov           dl,0   
                        mov           ah,2   
                        int           21h                    
                        loop  		  lp	   
                        mov           dl,mark  
                        mov           ah,2   
                        int           21h  
                        pop dx
                        pop ax
                        pop cx                       
                        ret   
kge               endp   
  ;----------------------------------
quit proc near
	lea	dx,bye
    mov	ah,09
    int	21h
	mov	ah,1
	int	21h
    	ret
quit endp 
  ;----------------------------------    
CODE ENDS
    END START

