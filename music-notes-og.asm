LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 200h
start:
      mov P2,#00h
      mov P1,#00h
      acall delay
	  acall delay
	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command
	  acall delay
	  mov dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  lcall freq
	  cringe: sjmp cringe
	  
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay
         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en        
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay         
         ret                  ;Return from routine
;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine		
;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "ROLLING TIME", 00H

org 400h
mov TMOD, #00010001b
freq:
	lcall final_1
	lcall final_2
	lcall final_3
	lcall final_2
	lcall final_4
	lcall silence
	lcall final_4
	lcall final_5
	jmp freq
	
final_1:
	mov r0, #03h
	here_1: djnz r0, callm_1
	ret
	
callm_1:
	mov r2, #0beh
	there_9: djnz r2, call_1
	jmp here_1
	
call_1: 
	lcall n1
	jmp there_9
	
final_2:
	mov r0, #03h
	here_2: djnz r0, callm_2
	ret
	
callm_2:
	mov r2, #0d6h
	there_10: djnz r2, call_2
	jmp here_2
	
call_2: 
	lcall n2
	jmp there_10
	
final_3:
	mov r0, #04h
	here_3: djnz r0, callm_3
	ret
	
callm_3:
	mov r2, #0abh
	there_11: djnz r2, call_3
	jmp here_3
	
call_3: 
	lcall n3
	jmp there_11
	
final_4:
	mov r0, #05h
	here_4: djnz r0, callm_4
	ret
	
callm_4:
	mov r2, #0d7h
	there_7: djnz r2, call_4
	jmp here_4
	
call_4: 
	lcall n4
	jmp there_7

final_5:
	mov r0, #06h
	here_5: djnz r0, callm_5
	ret
	
callm_5:
	mov r2, #09dh
	there_8: djnz r2, call_5
	jmp here_5
	
call_5: 
	lcall n5
	jmp there_8
	
silence:
	clr p0.7
	mov r1, #7eh
	here_7: djnz r1, there
	setb p0.7
	ret
	
there:
	lcall delay_1
	jmp here_7
	
delay_1:
	mov TH0, #00h
	mov TL0, #00h
	setb TR0
	here_6: jnb TF0, here_6
	clr TF0
	clr TR0
	ret
	
n1:
	setb p0.7
	lcall f1
	clr p0.7
	lcall f1
	ret
	
f1:
	mov r1, #50h
	there_1: djnz r1, tp1
	ret

tp1:
	lcall delay_20u
	jmp there_1
	
n2:
	setb p0.7
	lcall f2
	clr p0.7
	lcall f2
	ret
	
f2:
	mov r1, #47h
	there_2: djnz r1, tp2
	ret
	
tp2:
	lcall delay_20u
	jmp there_2
	
n3:
	setb p0.7
	lcall f3
	clr p0.7
	lcall f3
	ret
	
f3:
	mov r1, #3bh
	there_3: djnz r1, tp3
	ret
	
tp3:
	lcall delay_20u
	jmp there_3
	
n4:
	setb p0.7
	lcall f4
	clr p0.7
	lcall f4
	ret
	
f4:
	mov r1, #2fh
	there_4: djnz r1, tp4
	ret
	
tp4:
	lcall delay_20u
	jmp there_4

n5:
	setb p0.7
	lcall f5
	clr p0.7
	lcall f5
	ret
	
f5:
	mov r1, #35h
	there_5: djnz r1, tp5
	ret
	
tp5:
	lcall delay_20u
	jmp there_5
	
delay_20u:
	mov TL0, #0d8H
	mov TH0, #0ffH
	setb TR0
 there_6: jnb TF0, there_6
	clr TF0
	clr TR0
ret
	
end