org 0000h
ljmp start

org 000bh
jmp timer1

org 100h
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable


org 500h
start:
      mov P2,#00h
      mov P1,#0fh ;initial delay for lcd power up
	  lcall delay
	  lcall delay
	  lcall lcd_init      ;initialise LCD
	  lcall main

main:
	lcall delay_2s
	setb p1.4
	lcall main0
	lcall main1
	lcall main2
	pere: jmp pere

main0:
	mov a, #82h
	lcall lcd_command
	lcall delay
	mov dptr, #my_string3
	lcall lcd_sendstring
	lcall delay
	mov a, #0c2h
	lcall lcd_command
	lcall delay
	mov dptr, #my_string1
	lcall lcd_sendstring
	lcall delay

main1:
	mov TMOD, #01h
	setb EA
	setb ET0
	mov TL0, #00h
	mov TH0, #00h
	setb TR0
	here:jnb p1.3, there
	jmp here
	pmp: nop
	ret
	
main2:
	mov a, TH0
	acall hextoascii_1
	mov a, TL0
	acall hextoascii_2
	mov a, 30h
	acall hextoascii_3
	mov a, #81h
	lcall lcd_command
	lcall delay
	mov dptr, #my_string1
	lcall lcd_sendstring
	lcall delay
	mov a, #0c0h
	lcall lcd_command
	lcall delay
	mov dptr, #my_string2
	lcall lcd_sendstring
	lcall delay
	mov a,#0cah		 ;Put cursor on first row,3 column
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov a, 74h
	lcall lcd_senddata
	mov a, #0cch
	lcall lcd_command
	lcall delay
	mov a, 72h
	lcall lcd_senddata
	mov a, #0ceh
	lcall lcd_command
	lcall delay
	mov a, 73h
	lcall lcd_senddata
	lcall delay
	ret

timer1:
	inc 30h
	mov TH0, #00h
	mov TL0, #00h
	reti
	
there:
	clr TR0
	clr p1.4
	setb p1.7
	jmp pmp

hextoascii_1:
	clr c 
	subb a, #0ah
	jc num1
	add a, #41h
	jmp final1
	num1:
	add a, #3ah
	final1:
	mov 72h, a
ret

hextoascii_2:
	clr c 
	subb a, #0ah
	jc num2
	add a, #41h
	jmp final2
	num2:
	add a, #3ah
	final2:
	mov 73h, a
ret

hextoascii_3:
	clr c 
	subb a, #0ah
	jc num3
	add a, #41h
	jmp final3
	num3:
	add a, #3ah
	final3:
	mov 74h, a
ret
	
delay_2s:
	mov r0, #0c8h
	here_1: djnz r0, callm_1
	ret
	
callm_1:
	mov r1, #0fah
	there_1: djnz r1, callm_2
	jmp here_1

callm_2:
	mov r2, #04h
	there_2: djnz r2, call_1
	jmp there_1
	
call_1: 
	lcall delay_20u
	jmp there_2

delay_20u:
	mov TL0, #0d8H
	mov TH0, #0ffH
	setb TR0
 there_6: jnb TF0, there_6
	clr TF0
	clr TR0
ret
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en
	     lcall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en
         
		 lcall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en
         
		 lcall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en

		 lcall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en
		 lcall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 lcall delay
         clr   LCD_en
         lcall delay
		 lcall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         lcall lcd_senddata      ;send first char
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
	 
org 300h
my_string1:
         DB   "Reaction Time", 00H
my_string2:
		 DB   "Count is ", 00H
my_string3:
		 DB   "Toggle SW1", 00H
my_string4:
		  DB  " if LED glows", 00h
			 
end