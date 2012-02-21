 data segment   
  db1       db '		!!!error!!!   $'   
  db2       db 'continue   ?   (y/n)  :   $'   
  db3       db 'Goodbye   !$' 
  db4       db 'Please input the number (-32768~65535)you want to change:' ,'$' 
  db5       db 'press any buttom for goodbye !!!','$'
  db6       db 'Please input the number (-???~???)you want to change:' ,'$'
  _menu 	db 'please take a choice for the range of number that you want to chane',0ah,0dh 
      		db '	1,first _type(-32768~65535).',0ah,0dh
      		db '	2,second _type(-???~???).',0ah,0dh
      		db '	3,exit!',0ah,0dh
      		db '		Choice: $'
  flag		db	0
  flag1		db	0
  flag2		db	0
  print_times	db	2
  _bx		dw		0
  __bx		dw		0
  data       ends   

STACK SEGMENT	STACK
    ;此处输入堆栈段代码
    dw	100 dup (0)
STACK ENDS
  code               segment   
                        assume     cs:code,ds:data,ss:stack   
main               proc         far   
  ;---------------------------------- 
start:
                        push         ds   
                        mov          ax,0   
                        push         ax   
                        mov          ax,data   
                        mov          ds,ax 
                        
                        call	clear_screen
                        call	crlf
                        lea   	dx,_menu
                        mov 	ah,9   
                        int		21h
                        mov		ah,1
                        int		21h
                        cmp		al,'1'
                        jz		_main2
                        cmp		al,'2'
                        jz		_main1
                        cmp		al,'3'
                        jz		_out
                        lea   	dx,db1
                        mov 	ah,9   
                        int		21h	
                        mov 	ah,1   
                        int		21h	
                        call	crlf
                        jmp		start	
_main1:                        
                        call		main1
                        call		crlf
                        jmp			continue
_main2:                        
						call		main2
						call		crlf
						
continue:                   
						mov   dx,offset   db2   
                        mov ah,9   
                        int 21h
                        
                        call crlf    
  						mov ah,1   
  						int 21h               ;是否继续？？？   
  						cmp al,'n'                   
 						jnz 	start
_out: 						
 						call	exit   
                        
                        ret
main			endp   
;comment /*                     
main1               proc         near                            

start1:          		
			call 	crlf 
                        mov   	dx,offset   db6   
                        mov 	ah,9   
                        int		21h
                        mov		dx,0        ;此处加计数器，要将数控制在10位。
                        mov		bx,0
			;mov		_bx,0
			mov		__bx,0
                        mov		flag,0
                        mov		flag1,0
                        jmp		get_char
lop:                    
			;mov	flag1,1
get_char:						
			mov	_bx,bx    
			mov     bx,0  
           				
           		jmp		newchar1
fushu1:					
			cmp		flag,1
			jz		exit1
			mov		flag,1           				     
 						   
newchar1:      			
			mov           ah,1   
                        int           21h 
                        cmp           al,1bh   
                        jz             main1_out  
                        cmp           al,0dh   
                        jz            next1 
                        cmp           al,'-'   
                        jz            fushu1   
                        sub           al,30h   
                        jl            exit1   
                        cmp           al,9d   
                        jg            exit1   
                        cbw   
                        xchg          ax,bx   
                        mov           cx,10d   
                        mul           cx   
                        xchg          ax,bx   
                        add           bx,ax   
  			inc	dx 
  			cmp	dx,5
  			jz	lop 
  			jmp		newchar1               
  						  
exit1:            		
			call 	crlf   
                        mov           dx,offset   db1   
                        mov           ah,9   
                        int           21h                         ;如不是数字，则显示error.   
                        jmp           start1   
next1:        			
						mov		__bx,bx
						;cmp		flag1,1
						;jnz		no_bx
						
no_bx:						
						call 		crlf  ;换行
						cmp		flag,1
						jnz		_next1
						neg		__bx	
						cmp		_bx,0
						jnz		_neg
						mov		_bx,1
_neg:						
						neg		_bx				
_next1:					                
						mov		bx,_bx
						call 		printit_2						
						mov		bx,__bx					
						call 		printit_2
						mov		dl,'b'  
         					mov		ah,2
         					int		21h         				
         					call		crlf
						mov		bx,_bx
						call		printit_16
						mov		bx,__bx
						call		printit_16
						mov	dl,'h'  
         					mov	ah,2
         					int	21h 
main1_out:         					                  
  						call         crlf   
 
  					  ret  
main1               endp 
;*/  
  ;---------------------------------- 
main2               proc         near
start2:          		
						call 	crlf 
                        mov   	dx,offset   db4   
                        mov 	ah,9   
                        int		21h  
           				mov		dx,5        ;此处加计数器，要将数控制在5位。
           				mov     bx,0 
           				mov		flag,0
           				jmp		newchar2
fushu2:					
						cmp		flag,1
						jz		_exit1
						mov		flag,1           				     
 						  
newchar2:      			mov           ah,1   
                        int           21h   
                        cmp           al,0dh   
                        jz             next2
                        cmp           al,1bh   
                        jz             main2_out 
                        cmp           al,'-'   
                        jz            fushu2   
                        sub           al,30h   
                        jl            _exit1   
                        cmp           al,9d   
                        jg            _exit1   
                        cbw   
                        xchg          ax,bx   
                        mov           cx,10d   
                        mul           cx   
                        xchg          ax,bx   
                        add           bx,ax   
  						dec 		dx 
  						cmp			dx,0 
  						jnz         newchar2               
  						jmp			next2   
_exit1:            		call 		crlf   
                        mov           dx,offset   db1   
                        mov           ah,9   
                        int           21h                         ;如不是数字，则显示error.   
                        jmp           start2   
next2:        			
						call 		crlf  ;换行
						cmp			flag,1
						jnz			_next2
						neg			bx
_next2:						
                                                       
                        call 		printit_2
                        mov	dl,'b'  
         				mov	ah,2
         				int	21h           
						call		crlf	 ;换行                          

               			call 		printit_16
               			mov	dl,'h'  
         				mov	ah,2
         				int	21h
main2_out:         				                   
  						call        crlf 
  						
  					ret  
main2               endp  
printit_16 		proc         near
        		  
                        mov			flag2,0
                        mov           ch,4   
_rotate_16:         
 						mov           cl,4   
                        rol           bx,cl   
                        mov           al,bl   
                        and           al,0fh   
                        add           al,30h   
                        cmp           al,3ah   
                        jl            printit   
                        add           al,7h   
printit:       
  						cmp			al,'0'
  						jnz			s
  						cmp			flag2,0
  						jnz			s
  						mov			al,' '
  						jmp			j
  						
s:  
						mov			flag2,1						
j:						
  						mov           dl,al   
                        mov           ah,2   
                        int           21h   
                        dec           ch   
                        jnz           _rotate_16  
                          		  
        		  		
			ret  
printit_16        endp
       
printit_2         proc         near 
		mov 	cl,16
rotate_2:         
         
         rol 	bx,1
         jc 	one 
         mov 	dl,30h
         mov 	ah,02
         int 	21h
         dec 	cl
         jnz 	rotate_2
        
         ret
one:       
		 mov 	dl,31h
         mov 	ah,02
         int 	21h
         dec 	cl
         jnz 	rotate_2  
                           
         ret  
  printit_2        endp   
  ;-------------------------------   
  crlf               proc         near   ;换行
                       
                        mov           dl,0dh   
                        mov           ah,2   
                        int           21h   
                        mov           dl,0ah   
                        mov           ah,2   
                        int           21h   
                        ret   
  crlf               endp  
  ;-------------------------------  
exit	proc	near
  		call crlf 
        mov   dx,offset   db3   
        mov ah,9  
        int 21h 
        call crlf
        mov   dx,offset   db5  
        mov ah,9   
        int 21h        
        mov ah,1
        int 21h
        mov ax,4c00h
        int 21h  
exit	endp 
  ;------------------------------- 
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
  code               ends   
                        end start
                        
                        
                        
                        
                          
    
