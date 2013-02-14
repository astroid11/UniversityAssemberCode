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
	db 'Please enter chars : $'
MESSAGE2:
	db 'Character entered : $'	

CHAR20:
	db	20 dup(?)
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
    
    MOV	    DX,OFFSET MESSAGE1
    MOV     AH,09h
    INT	    21h
    
    MOV     BX,OFFSET CHAR20
    MOV     AH,01h
    INT	    21h
    MOV	    [BX],AL    
    
    MOV	    DX,OFFSET MESSAGE2
    MOV	    AH,09h
    INT	    21h
    
    MOV     DX,OFFSET CHAR20
    MOV	    AH,09h
    INT	    21h        
    
    MOV     AH,4Ch
    INT     21h
        








; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

