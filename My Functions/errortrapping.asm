TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

KEYREAD		1 DUP(?)
ERROR1		"You entered an invalid character buddy!",13,10,"$" 
ERROR2		"Press any key to restart program",13,10,"$" 

; TODO: add your data here!!!!

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

BEGIN
    CALL    READKEY
    	
    
    CALL    EXIT
; return to operating system:
    RET
START   ENDP

;=-=-=-=-=-=-=-=-=-=-=-=-=-Terminate Program-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
EXIT:
    MOV	    AH, 4Ch			; Call dos function to terminate program using		 
    INT	    21h				; Interrupt 21h


START   ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Read Character from keyboard =-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
READKEY PROC

    MOV	    AH,01h			; Call the dos function to read a char 	
    INT	    21h				; to the screen using interupt 21h
    RET
    
READKEY ENDP
    
;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write String to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
WRITESTRING PROC

    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
WRITESTRING ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

