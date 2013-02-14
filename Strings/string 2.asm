TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

CHAR20:
	db	20 DUP(?)
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
    MOV	    BX,OFFSET CHAR20		; Pointer Storage location for string

;-=-=-=-=-=-=-=-=-=-=-=-=-= Start of Program-=-=-=-=-=-=-=-=-=-=-=-=-=-
MAIN:
    MOV	    CX,20			;Set character counter to 20
    CALL    READKEYS			;Go and read the keys from keyboard
    MOV	    DL,13			;Write Carriage Return to screen
    CALL    SCREENWRITE			;Call write screen function
    MOV	    DL,10			;Write New Line to screen
    CALL    SCREENWRITE			;Call write screen function
    MOV	    AX,CX			;Checks how many chars where used
    MOV	    CX,20			;and sets string length counter to
    SUB     CX,AX			;how many chars where entered.
    DEC	    BX				;(Used for enter key)
    CALL    SHOWKEYS			;Show all keys back to the screen
    MOV     AH,4Ch			;Terminate Process using	
    INT     21h				;Dos Function Call

; return to operating system:
    RET
START   ENDP
;-=-=-=--==--=-=-=-=-=-=-=-= End of Start -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;-=-=-=-=-=-=-=-=-=-=-=-=-=- Readkeys from keyboard -=-=-=-=-=-=-=-=-=-=-=
READKEYS PROC
    MOV     AH,01h    			;Get a char from the keyboard using
    INT	    21h				;Dos function calls
    CMP	    AL,13			;Was the enter key pressed?
    JZ	    STOP1			;Finish reading keys if enter is pressed
    MOV	    [BX],AL			;Store Character in memory
    INC	    BX	
    DEC	    CX				;Decrement the string length counter	
    CMP	    CX,0			;Is the string length counter 0?
    JZ	    STOP1			;
    JMP	    READKEYS			;Read value from keyboard again	    		
STOP1:
    RET 				; Back to main
READKEYS ENDP
	

;=-=-=-=-=-=-=-=-=-=-=-=- Showkeys back to screen -=-=-=-=-=-=-=-=-=-=-=

SHOWKEYS PROC
    	
    MOV	    DL,[BX]			; Load character from string
    CALL    SCREENWRITE			; Write character to Screen
    DEC	    CX				; Decrement the string length counter
    CMP	    CX,0			; Is the string length counter 0?
    JZ	    STOP2			;
    DEC	    BX	    			;
    JMP	    SHOWKEYS
STOP2:    
    RET  
SHOWKEYS ENDP

;=--=-=-=-=-=-=-=-=-=-=-= Screen Write Procedure -=-=-=-=--=-=-=-=-=-=-=
SCREENWRITE PROC
    MOV	    AH,02h			; Write string to screen using
    INT	    21h				; Dos Function Call  
    RET	
SCREENWRITE ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

