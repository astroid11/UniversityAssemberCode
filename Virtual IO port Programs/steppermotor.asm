TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

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


	MOV AL, 001b ; initialize.
	OUT 7, AL

	MOV AL, 011b ; half step 1.
	OUT 7, AL

	MOV AL, 010b ; half step 2.
	OUT 7, AL

	MOV AL, 110b ; half step 3.
	OUT 7, AL
	MOV AL, 100b ; half step 4.
	OUT 7, AL
	
	MOV AL, 110b ; initialize.
	OUT 7, AL

	MOV AL, 010b ; half step 1.
	OUT 7, AL

	MOV AL, 001b ; half step 2.
	OUT 7, AL

	MOV AL, 110b ; half step 3.
	OUT 7, AL
	MOV AL, 100b ; half step 4.
	OUT 7, AL






; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

