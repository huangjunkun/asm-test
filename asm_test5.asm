		;.model	small

STACK SEGMENT	STACK
    ;此处输入堆栈段代码
    dw	100 dup (0)
STACK ENDS

		;.data	
data	segment
endcde		db	0
handle		dw	?
ioarea		db	32	dup	(' ')
maxlen		db	21
pathnamlen	db	?
pathnam		db	21	dup(' '),0
openmsg		db	'* * * open error * * *',0dh,0ah
readmsg		db	'* * * read error * * *',0dh,0ah
row		db	0,'$'
input_pathnam	db	'please input the pathname of file that you want to print out:  ','$'
replay    db 'continue? (y/n)',0ah,0dh,'$'
bye       db 'press any buttom for goodbye !!!','$'
data	ends
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
start:
	mov	ax,data
	mov	ds,ax

	call	begin
	call	crlf
	lea	dx,replay
      	mov	ah,9
      	int	21h
      	mov	ah,1
      	int	21h
      	cmp	al,'y'
     	jz	start

	call	quit

	mov	ax,4c00h
	int	21h

begin	proc	near

	call	clear_screen
	mov	ax,data
	mov	ds,ax
comment /*
	mov	ah,0ah
	lea	dx,maxlen
	int	21h
	mov	al,pathnamlen
	cbw
	mov	si,ax
	dec	si
	mov	pathnam[si],' '
	mov	ah,1
	int	21h
	*/

	call	crlf
	mov	ah,9
	lea	dx,input_pathnam
	int	21h
	lea	bx,pathnam
i1:   
		mov 	ah,1
      	int 	21h
      	cmp 	al,0dh
      	je 		next
      	mov 	[bx],al
      	inc 	bx
      	jmp 	i1
next:
	mov	ax,data
	mov	es,ax
	mov	ax,0600h
	call	scren
	call	curs
	call	openh
	cmp	endcde,0
	jne	a1
contin:
	call	readh
	cmp	endcde,0
	jnz	a1
	call	disph
	jmp	contin
a1:
	ret
begin	endp

openh	proc	near
	MOV	ah,3dh
	mov	al,0
	lea	dx,pathnam
	int	21h
	jc	b1
	mov	handle,ax
	ret
b1:
	mov	endcde,01
	lea	dx,openmsg
	call	errm
	ret
openh	endp

readh	proc	near
	mov	ah,3fh
	mov	bx,handle
	mov	cx,32
	lea	dx,ioarea
	int	21h
	jc	c1
	cmp	ax,0
	je	c2
	cmp	ioarea,1ah
	je	c2
	ret
c1:	lea	dx,readmsg
	call	errm
c2:	mov	endcde,01
	ret
readh	endp

disph	proc	near
	mov	ah,40h
	mov	bx,01
	mov	cx,32
	lea	dx,ioarea
	int	21h
	cmp	row,24
	jae	d1
	inc	row
	ret
d1:	mov	ax,0601h
	call	scren
	call	curs
	ret
disph	endp

scren	proc	near
	mov	bh,1eh
	mov	cx,0
	mov	dx,184fh
	int	10h
	ret
scren	endp

curs	proc	near
	mov	ah,2
	mov	bh,0
	mov	dh,row
	mov	dl,0
	int	10h
	ret
curs	endp

errm	proc	near
	mov	ah,40h
	mov	bx,01
	mov	cx,20
	int	21h
	ret
errm	endp
quit proc near
	lea 	dx,bye
   	mov	ah,09
    	int	21h
	mov	ah,1
	int	21h
    	ret
quit endp 
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

CODE ENDS
	end	start


