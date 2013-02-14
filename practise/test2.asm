TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

MESSAGE1:
	db	10 DUP(?)
	db	'$'

MESSAGE2:	
	db	'Please enter a value : ',10,13,'$'	
	
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

     	 




    MOV	    AH,4ch		; Exit program using dos function
    INT	    21h			;

; return to operating system:
    RET
START   ENDP

WRITESTRING PROC


WRITE

READKEY PROC

    MOV     AH,01h		; Use dos function to get key from keyboard
    INT	    21h			; call interrupt

READKEY ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

