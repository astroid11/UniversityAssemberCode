TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

LOCATIONA db 25 DUP(?)
LOCATIONB db 25 DUP(?)
Counter	  db 1 DUP(?)
EQUAL     db 13,10,'The string transfer was successful $'
UNEQUAL	  db 13,10,'The string transfer was not successful $'	
NEWLINE	db      13,10,'$'
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
    
    MOV	    CX,0			;Set character counter to 0
    MOV     BX,OFFSET LOCATIONA         ;
    CALL    READKEYS			;Go and read the keys from keyboard
    MOV     BX,OFFSET Counter		;Load up counter variable
    MOV     [BX],CX			;Save counter into temp variable
    MOV     SI,OFFSET LOCATIONA		;Do the transfer
    MOV     DI,OFFSET LOCATIONB		;// 
    REP     MOVSB			;//
    MOV     CX,[BX]			;Load up temp counter
    MOV     SI,OFFSET LOCATIONA		;Load up the compare sour
    MOV     DI,OFFSET LOCATIONB		;Load up the compare destination
    REP	    CMPSB			;Compare the characters		
    JNZ	    ERROR
    MOV     DX,OFFSET EQUAL
    JMP     FINISH	
ERROR:
    MOV     DX,OFFSET UNEQUAL	
FINISH:    
    CALL    WRITESTRING		    	
    CALL    EXIT      

; return to operating system:
    RET
START   ENDP


;-=-=-=-=-=-=-=-=-=-=-=-=-=- Readkeys from keyboard -=-=-=-=-=-=-=-=-=-=-=
READKEYS PROC
    MOV     AH,01h    			;Get a char from the keyboard using
    INT	    21h				;Dos function calls
    CMP	    AL,13			;Was the enter key pressed?
    JZ	    STOP1			;Finish reading keys if enter is pressed
    MOV	    [BX],AL			;Store Character in memory
    INC	    BX	
    INC	    CX				;Decrement the string length counter	
    CMP	    CX,25			;Is the string length counter 0?
    JZ	    STOP1			;
    JMP	    READKEYS			;Read value from keyboard again	    		
STOP1:
    MOV     [BX],'$'
    INC     CX
    RET 				; Back to main
READKEYS ENDP

;=--=-=-=-=-=-=-=-=-=-=-= Screen Write Procedure -=-=-=-=--=-=-=-=-=-=-=
SCREENWRITE PROC
    MOV	    AH,02h			; Write string to screen using
    INT	    21h				; Dos Function Call  
    RET	
SCREENWRITE ENDP

;=-=-=-=-=-=-=-=-=-=-=-=-=-Terminate Program-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
EXIT        PROC
    MOV	    AH, 4Ch			; Call dos function to terminate program using		 
    INT	    21h				; Interrupt 21h
EXIT        ENDP
;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write New Line to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	

LINENEW PROC

    MOV	    DX,OFFSET NEWLINE
    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
LINENEW ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write String to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
WRITESTRING PROC
    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
WRITESTRING ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

