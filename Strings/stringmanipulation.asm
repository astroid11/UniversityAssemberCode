TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

DISPLAYSTRING: 
	db	13,10

THREECHARS:	
	db	3 DUP(?)
	
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
    mov     bx,OFFSET THREECHARS	; Point to storage location for first character


BEGIN:	
	mov	ah,1			; Dos keyboard read function
	int	21h			; Call interupt
	dec	al			; Subtract 1 from the character
	mov	[bx],al			; store modified character
	inc 	                      			; point to starage location for next character

	int	21h			; Call interupt
	dec	al			; Subtract 1 from the character
	mov	[bx],al			; store modified character
	inc 	bx			; point to starage location for next character
	
	int	21h			; Call interupt
	dec	al			; Subtract 1 from the character
	mov	[bx],al			; store modified character
	mov	dx,OFFSET DISPLAYSTRING
	
	mov	ah,9
	int	21h
	mov	ah,4ch
	int 	21h

; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

