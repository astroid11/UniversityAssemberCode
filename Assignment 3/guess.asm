TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

WELCOME: 
	db	'Welcome to the guessing game...$'
PROMPT: 
	db	'Please enter a number between 0 and 99 : $'
GREATER: 
	db	'Your number is to high, try a lower number...$'
SMALLER: 
	db	'Your number is to low, try a higher number...$'
EQUAL: 
	db	'Well done! The number you guessed is correct. Number of guesses : $'
PLAY: 
	db	'Would you like to play again? [y/n] : $'
NEWLINE:
	db      13,10
	db	'$'
COUNTER:
	db	1 DUP(?)
	db	'$'		

DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX


;=-=-=-=-=-=-=-=-=-=-=-=-=-Display Welcome Screen-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
MAIN:   
    CALL    LINENEW
    CALL    LINENEW
    CALL    RESET    
   
;-=-=-=-=-=-=-=-=-=-=-=-=-=Get Random Number using System Clock=-=-=-=-=-=-=-=-=-=-=-=-    	
    MOV     DX,OFFSET WELCOME		; Load the welcome string
    CALL    WRITESTRING			; Call function to write it to screen
    CALL    LINENEW			; Call function to write newline to screen
    MOV	    AH,00h	  		; Call the System Time Function (BIOS)
    INT	    1Ah		  		; //
    MOV	    AL,01011110b  		; Take the Recieved Time Value and remove the 128 and 32 bits
    AND	    AL,DL	  		; to make sure the value is less than 99 (Actually 95)
    MOV	    CH,AL			; Move the random value 
   
;==-=-=-=-Display Get number prompt and get number from keyboard-=-=-=-=-=-=-=-=-=-=-=-
AGAIN:
    
    MOV     DX,OFFSET PROMPT		; Load the prompt string
    CALL    WRITESTRING			; call function to write string to screen
    CALL    READKEY			; call function to read character from keyboard
    SUB	    AL,30h			; Convert asci value to number (-30h or -48)
    PUSH    AX				; Save the entered number to temp area
    CALL    READKEY			;
    CMP     AL,13			;
    JE	    SKIPCHAR2			;
    SUB	    AL,30h			; convert asci value to number
    MOV     CL,AL			; Move the received value
    POP	    AX				;
    MOV	    BL,10
    MUL     BL				; Save the value as a tens number
    ADD	    CL,AL			; Add the values together to get full number
    JMP	    CARRYON	
SKIPCHAR2:
    POP     AX				; Move temp value back
    MOV	    CL,AL			; save the value to the register for entered value
    
;-=-=-=-=-==-=-=-=-=-=-=-=-= Compare Random Number to Entered Number =-=-=-=-=-=-=-=-=-=-=
CARRYON:
    MOV	    BX,OFFSET COUNTER		; Load up the counter address
    MOV	    DL,[BX]			; Load Counter value
    INC	    DL				; Add 1 to counter
    MOV     [BX],DL			; Load Counter back to memory
    CALL    LINENEW			; Call function to write newline to screen
    CMP     CL,CH			; Compare the random number to entered number
    JG	    GREAT			; If the entered number is greater then display greater message
    JL      SMALL			; If the entered number is smaller then display smaller message
    MOV	    DX,OFFSET EQUAL		; If the entered number is equal then display equal message
    CALL    WRITESTRING
    MOV     DX,OFFSET COUNTER		;
    CALL    WRITESTRING			;
    JMP     WHATNOW			; What now heh?

GREATS:
    CALL GREAT
SMALLS:    
    CALL SMALL

WHATNOW:
    CALL    LINENEW
    MOV     DX,OFFSET PLAY				; Does the user want to try again?
    CALL    WRITESTRING                                 ;
    CALL    READKEY					;
    CMP	    AL,'y'					; check if input is y for yes						
    JZ	    MAIN					; If the result is true zflag=1, therefore do program over
    CMP	    AL,'Y'					; check if input is Y for yes						
    JZ	    MAIN
    CMP	    AL,'n'					; check if input is n for no						
    JZ	    EXIT					; If the result is true zflag=1, therefore exit program 
    CMP	    AL,'N'					; check if input is N for no						
    JZ	    EXIT					; If the result is true zflag=1, therefore exit program 	

;=-=-=-=-=-=-=-=-=-=-=-=-=-Terminate Program-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
EXIT:
    MOV	    AH, 4Ch			; Call dos function to terminate program using		 
    INT	    21h				; Interrupt 21h


START   ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Read Character from keyboard =-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
READKEY PROC

    MOV	    AH,01h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
READKEY ENDP
    
;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write String to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
WRITESTRING PROC

    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
WRITESTRING ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write New Line to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	

LINENEW PROC

    MOV	    DX,OFFSET NEWLINE
    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
LINENEW ENDP

  
;-=-=-=-=-=-=-=-=-=-=-=-=-=-Reset the number of guesses counter-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	

RESET PROC

    MOV	    BX,OFFSET COUNTER		; Load Counter Variable
    MOV     [BX],48			; Load number 1 into variable
    RET
    
RESET ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Reset the number of guesses counter-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	

GREAT PROC
    
    MOV	    DX,OFFSET GREATER
    CALL    WRITESTRING
    CALL    LINENEW			; Call function to write newline to screen
    JMP	    AGAIN	
    RET	  
    
GREAT ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Reset the number of guesses counter-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	

SMALL PROC

    MOV	    DX,OFFSET SMALLER
    CALL    WRITESTRING
    CALL    LINENEW			; Call function to write newline to screen
    JMP	    AGAIN		    
    RET    
    
SMALL ENDP


; return to operating system:
    RET


;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

