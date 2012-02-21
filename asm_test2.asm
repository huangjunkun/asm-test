DATAS SEGMENT
    ;此处输入数据段代码
menu db 'please take a choice from following',0ah,0dh 
     db '	1,Input.',0ah,0dh
     db '	2,Sort on name _and display.',0ah,0dh
     db '	3,Sort on masm _and display.',0ah,0dh
     db '	4,Display.',0ah,0dh
     db '	5,Quit.',0ah,0dh
     db '	Choice: $'
error  db 'error   $'
num_error	db '	!!!error the number that you input error!!!   $'
no_student	db 'error  NO STUDENT!!! $'
_input db 'Input for name,age _and masm: ','$'
list_for_display db 'NAME                AGE    MASM ','$'
replay    db 'continue? (y/n)',0ah,0dh,'$'
bye       db 'press any buttom for goodbye !!!','$'
students dw 0
_students dw 0
_i	db	0   
_j	db	0  
_k	db	0 
m	dw	0  
n	dw	0    
_name db 10 dup(20 dup(0)),'$'
_age  dw 10 dup(0),'$'
_masm dw 10 dup (0),'$' 
namesav db 20 dup(0)
;age_  dw 10 dup(0)
;masm_ dw 10 dup (0)
Inputnum	db	0   
_nameaddr	dw	?
endaddr		dw	?
_ageaddr	dw	?
_masmaddr	dw	?	
save_cnt dw ?
start_addr dw ?
div_num	dw	10000,1000,100,10,1
dec_buf	db	5 dup(' ')
	db	'$'
flag	db	1
swapped	db	0      
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
  dw  100 dup (0) 
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
main proc far
START:
    ;此处输入代码段代码
    MOV AX,DATAS
    MOV DS,AX
    mov	es,ax
Restrat:    
	lea 	dx,menu
    mov		ah,09
    int		21h
    mov 	ah,1
    int 	21h
    call	crlf
    cmp 	al,31h
    jz		toinput
    cmp		al,32h
    jz 		toname
    cmp 	al,33h
    jz 		tomasm
    cmp 	al,34h
    jz 		todisplay
    cmp 	al,35h
    jz 		toquit
    call	crlf
    lea 	dx,error
    mov 	ah,09
    int 	21h 
      
    jmp 	Restrat 
toinput:    	
			call	input
			call	crlf	
          	jmp 	Restrat 
toname:     
			call	sort_on_name
          	jmp 	todisplay
tomasm:    
			call 	sort_on_masm
         	jmp 	todisplay
todisplay:    	
			mov		ax,students
			mov		_students,ax
			call 	display
			call	crlf
			mov		ax,_students
			mov		students,ax
			mov 	ah,1
    			int 	21h
   			call	crlf
      			jmp 	Restrat
toquit:    
			call	crlf
			call 	quit
    
    
    MOV AH,4CH
    INT 21H
main endp 

  ;----------------------------------
input proc near      
      push ds
      push ax
      push cx
      push si
      push di
      
      cmp	 students,0
      jnz	nextinput
      mov	 bx,0
      mov	 si,0
      mov	 di,0
      mov	 ax,datas
      mov	 ds,ax
      lea	 bx,_name
      lea 	 si,_age
      lea	 di,_masm
	  jmp	reinput	
nextinput:
	  mov	bx,_nameaddr
      ;add	bx,20
      mov	si,_ageaddr
	  mov	di,_masmaddr
reinput:
	  mov	_nameaddr,bx	        
      lea 	dx,_input
      mov   ah,9
      int   21h
      call  crlf
      	
i1:   mov 	ah,1
      int 	21h
      cmp 	al,0dh
      je 	next_to_age
      cmp 	al,1bh
      je 	_out
      mov 	[bx],al
      inc	bx
      jmp	i1
next_to_age:		
      mov dl,0ah
      mov ah,02
      int 21h   
i2:   
	  mov ah,1
      int 21h
      cmp al,0dh
      je next_to_masm
      cmp 	al,1bh
      je 	_out
      cmp 	al,'0'
      jb 	input_error
      cmp 	al,'9'
      ja 	input_error
      mov [si],al
      inc si
      jmp i2
next_to_masm: 
      mov dl,0ah
      mov ah,02
      int 21h
i3:   mov ah,1
      int 21h 
      cmp al,0dh
      je i4
      cmp 	al,1bh
      je 	_out
      cmp 	al,'0'
      jb 	input_error
      cmp 	al,'9'
      ja 	input_error
      mov [di],al
      inc di
      jmp i3     
i4: 
      inc	students
      mov	_ageaddr,si
	  mov	_masmaddr,di
	  mov	bx,_nameaddr
      add	bx,20      
      mov	_nameaddr,bx
      mov dl,0ah
      mov ah,02
      int 21h
      lea	dx,replay
      mov	ah,9
      int	21h
      mov	ah,1
      int	21h
      cmp	al,'y'
      jnz	_out      
      call	crlf
      jmp	reinput      
      
input_error:
		lea 	dx,num_error
      	mov   ah,9
      	int   21h 
      	call	crlf     
_out:  
      call crlf
      pop di
      pop si
      pop cx
      pop ax
      pop ds
      ret
input endp 
  ;-------------------------------  
sort_on_name	 proc near
      push ax
      push cx
      push si
      push di
      push	bx
      
      	mov	di,_nameaddr
      	sub	di,40
 		mov	endaddr,di
g20:		
		mov	swapped,0
		lea	si,_name
g30:		
		mov		cx,20
		mov		di,si
		add		di,20
		mov		m,di
		mov		n,si
		mov		bx,si
		sub		bx,offset _name
		repe    cmpsb
		jbe	g40
		
		mov		cl,10
		mov		ax,bx
		div		cl
		mov		ah,0
		mov		bx,ax
		mov		ax,_masm[bx]
		xchg	ax,_masm[bx+2]
		mov		_masm[bx],ax
		
		mov		ax,_age[bx]
		xchg	ax,_age[bx+2]
		mov		_age[bx],ax
		
		call	h10xchg	

g40:			
		mov	si,m
		cmp	si,endaddr
		jbe	g30
		cmp	swapped,0
		jnz	g20
      
      pop bx
      pop di
      pop si
      pop cx
      pop ax
      
      ret
sort_on_name	 endp 


  ;-------------------------------  

h10xchg		proc	near
		mov	cx,10
		lea	di,namesav
		mov	si,n
		rep	movsw


		mov	cx,10
		mov	di,n
		rep	movsw
		

		mov	cx,10
		lea	si,namesav
		rep	movsw
		mov	swapped,1
		ret

h10xchg		endp

  ;---------------------------------- 

sort_on_masm	proc	near
		push	ax
		push	cx
		push	bx
		push	si
		push	di
		
		cmp		students,0
      	je		sort_out
		mov		cx,students
		dec		cx
		cmp		cx,0
		jz		sort_out
loop1:	
		mov		di,cx
		mov		bx,0
loop2:	
		mov		al,byte ptr _masm[bx]
		cmp		al,byte ptr _masm[bx+2]
		jg		continue
		jl		change
		mov		al,byte ptr _masm[bx+1]
		cmp		al,byte ptr _masm[bx+3]
		jge		continue
change:
		mov		ax,_masm[bx]
		xchg	ax,_masm[bx+2]
		mov		_masm[bx],ax
;comment /*		;多行注释
		mov		ax,_age[bx]
		xchg	ax,_age[bx+2]
		mov		_age[bx],ax	
		;???交换_name中的值
		push	cx
		mov		n,ax
		mov		m,bx
		mov		ax,bx
		mov		cl,10
		mul		cl
		mov		bx,ax
		mov		ax,n
		call	xchgname
		mov		bx,m
		pop	cx
		;*/;多行注释
continue: 
		add		bx,2
		loop	loop2
		
		mov		cx,di
		loop	loop1		
		
sort_out:
		pop		di
		pop		si
		pop		bx
		pop		cx
		pop		ax
		ret
sort_on_masm	endp
  ;------------------------------- 
xchgname proc near
      push ax
      push cx
      push si
      push di
      
      	cld
      	mov		cx,10
		lea		di,namesav
		lea		si,_name[bx]
		rep		movsw
		
		mov		cx,10
		lea		di,_name[bx]
		rep		movsw
		
		mov		cx,10
		lea		si,namesav
		rep		movsw
      
      pop di
      pop si
      pop cx
      pop ax
      ret
xchgname  endp 

 ;-------------------------------     
   
display proc near
	  push ds
      push ax
      push bx
      push cx
      push si
      push di
      cmp	students,0
      je	_nostudent
      
      mov bx,0
      mov si,0
      mov di,0
      mov ax,datas
      mov ds,ax
      call	crlf
      lea	dx,list_for_display
      mov	ah,9
      int	21h
	  call	crlf
      lea 	bx,_name
      lea 	si,_age
      lea 	di,_masm
      
_lp1: 
		call	crlf
		mov	_i,20
lp2:
      mov	dl,[bx]
      mov 	ah,2
      int 	21h
      inc	bx
      dec	_i
      jnz	lp2
      mov	_i,2      
lp3:
	  mov	dl,[si]
	  mov	ah,2
	  int	21h
	  inc	si
	  dec	_i
	  jnz	lp3
	  call	kge
	  mov	_i,2
lp4:
	  mov	dl,[di]
	  mov	ah,2
	  int	21h
	  inc	di
	  dec	_i
	  jnz	lp4

	  dec	students
 	  jnz	_lp1
 	  JMP	dispout
_nostudent:
 	  lea	dx,no_student
      mov	ah,9
      int	21h
dispout:		
	  pop di
      pop si
      pop cx
      pop bx
      pop ax
      pop ds

	ret
display endp
  ;-------------------------------   
quit proc near
	 lea 	dx,bye
   	 mov	ah,09
   	 int	21h
    ret
quit endp 


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
;----------------------------------  
kge               proc         near   ;空格
                        push cx
                        push ax
                        push dx
                                              
                        mov 	cx,4
                       
lp:        
             		mov           dl,20h   
                        mov           ah,2   
                        int           21h                    
                        loop  		lp
                        
                                               
                        pop dx
                        pop ax
                        pop cx                       
                        ret   
kge               endp   
  ;---------------------------------- 
   
  crlf               proc         near   ;换行
                     push	ax
                     push	dx  
                        mov           dl,0dh   
                        mov           ah,2   
                        int           21h   
                        mov           dl,0ah   
                        mov           ah,2   
                        int           21h
                      pop	dx
                      pop	ax   
                        ret   
  crlf               endp   



   
  
CODES ENDS
    END START