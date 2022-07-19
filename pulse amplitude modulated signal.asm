; This subroutine writes characters on the LCD
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
	  ;initial delay for lcd power up

	;here1:setb p1.0
      lcall delay
	;clr p1.0
	  lcall delay
	;sjmp here1


	  lcall lcd_init      ;initialise LCD
	lcall levelmaker
	lcall pam
	 

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

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "Level 1", 00H
my_string2:
         DB   "Level 2", 00H
my_string3:
         DB   "Level 3", 00H
my_string4:
         DB   "Level 4", 00H
my_string5:
		 DB   "Value:", 00H

org 400h
levelmaker:
	mov a, #78h
	mov b, #10h
	div ab
	mov 66h, b
	mov 67h, a
	mov a, #34h
	mov b, #10h
	div ab
	mov 68h, b
	mov 69h, a
	ret
	
pam:
	mov a, 66h
	swap a
	mov p1, a
	lcall ascii_1
	 mov a,#84h		 ;Put cursor on first row,5 column
	 lcall lcd_command	 ;send command to LCD
	 lcall delay
	 mov   dptr,#my_string1	  ;Load DPTR with sring1 Addr
	 lcall lcd_sendstring	   ;call text strings sending routine
	 mov a,#0C3h		  ;Put cursor on second row,3 column
	 lcall lcd_command
	 lcall delay
	 mov dptr,#my_string5
	 lcall lcd_sendstring
	 mov a, 79h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 78h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 77h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 76h
	 lcall lcd_senddata
	 lcall delay
	//Convert to ASCII 
	//Display Level 1 on LCD
	//Display value on LCD
	lcall delay_1s 
	mov a, 67h 
	swap a
	mov p1, a
	lcall ascii_2
	 mov a,#84h		 ;Put cursor on first row,5 column
	 lcall lcd_command	 ;send command to LCD
	 lcall delay
	 mov   dptr,#my_string2	  ;Load DPTR with sring1 Addr
	 lcall lcd_sendstring	 ;call text strings sending routine
	 mov a,#0C3h		  ;Put cursor on second row,3 column
	 lcall lcd_command
	 lcall delay
	 mov dptr,#my_string5
	 lcall lcd_sendstring
	 mov a, 83h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 82h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 81h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 80h
	 lcall lcd_senddata
	 lcall delay
	//Convert to ASCII 
	//Display Level 1 on LCD
	//Display value on LCD
	lcall delay_1s
	mov a, 68h
	swap a
	mov p1, a
	lcall ascii_3
	 mov a,#84h		 ;Put cursor on first row,5 column
	 lcall lcd_command	 ;send command to LCD
	 lcall delay
	 mov   dptr,#my_string3	  ;Load DPTR with sring1 Addr
	 lcall lcd_sendstring	   ;call text strings sending routine
	 mov a,#0C3h		  ;Put cursor on second row,3 column
	 lcall lcd_command
	 lcall delay
	 mov dptr,#my_string5
	 lcall lcd_sendstring
	 mov a, 87h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 86h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 85h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 84h
	 lcall lcd_senddata
	 lcall delay
	//Convert to ASCII 
	//Display Level 1 on LCD
	//Display value on LCD
	lcall delay_1s
	mov a, 69h
	swap a
	mov p1, a
	lcall ascii_4
	 mov a,#84h		 ;Put cursor on first row,5 column
	 lcall lcd_command	 ;send command to LCD
	 lcall delay
	 mov   dptr,#my_string4	  ;Load DPTR with sring1 Addr
	 lcall lcd_sendstring	   ;call text strings sending routine
	 mov a,#0C3h		  ;Put cursor on second row,3 column
	 lcall lcd_command
	 lcall delay
	 mov dptr,#my_string5
	 lcall lcd_sendstring
	 mov a, 91h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 90h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 89h
	 lcall lcd_senddata
	 lcall delay
	 mov a, 88h
	 lcall lcd_senddata
	 lcall delay
	//Convert to ASCII 
	//Display Level 1 on LCD
	//Display value on LCD
	lcall delay_1s
	ljmp pam
	
delay_1s:
	mov 31h, #1fh
	loop: lcall delay_1u
	djnz 31h, loop
	ret
	
delay_1u:
	mov TMOD, #01H
	mov TL1, #0cch
	mov TH1, #0f8h
	setb TR0
	here: jnb TF0, here
	clr TF0
	clr TR0
	ret

ascii_1:
	mov a, 66h
	lcall convert
	mov 76h, a
	mov a, 66h
	rr a
	lcall convert
	mov 77h, a
	mov a, 66h
	rr a
	rr a
	lcall convert
	mov 78h, a
	mov a, 66h
	rr a
	rr a
	rr a
	lcall convert
	mov 79h, a
	ret
ascii_2:
	mov a, 67h
	lcall convert
	mov 80h, a
	mov a, 67h
	rr a
	lcall convert
	mov 81h, a
	mov a, 67h
	rr a
	rr a
	lcall convert
	mov 82h, a
	mov a, 67h
	rr a
	rr a
	rr a
	lcall convert
	mov 83h, a
	ret
ascii_3:
	mov a, 68h
	lcall convert
	mov 84h, a
	mov a, 68h
	rr a
	lcall convert
	mov 85h, a
	mov a, 68h
	rr a
	rr a
	lcall convert
	mov 86h, a
	mov a, 68h
	rr a
	rr a
	rr a
	lcall convert
	mov 87h, a
	ret
ascii_4:
	mov a, 69h
	lcall convert
	mov 88h, a
	mov a, 69h
	rr a
	lcall convert
	mov 89h, a
	mov a, 69h
	rr a
	rr a
	lcall convert
	mov 90h, a
	mov a, 69h
	rr a
	rr a
	rr a
	lcall convert
	mov 91h, a
	ret
	
convert:
	anl a, #01h
	add a, #30h
	ret

end
	