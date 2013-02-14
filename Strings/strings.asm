TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

;=-=-=-=-=-=-=-=-=Assign Strings-=-=-=-=-=-=-=-=-=-=-=-	
TIMPROMPT:
	db	'Is it after 12 noon (y/n) ?$'		;Loads string
GOODMORNMSG:
	db	0Dh,0Ah,'Good Morning, World!',0Dh,0Ah,'$'   ;Loads string
GOODAFTNOON:
	db 	0Dh,0Ah,'Good Afternoon, World!',0Dh,0Ah,'$'	;Loads string


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


;=-=-=-=Load Strings and display to screen-=-=-=-=-=-=-=	

	mov	dx,offset TIMPROMPT			; Get the address of time prompt
	mov 	ah,9				        ; Dos print string function 
	int 	21h					; Call Dos function

;-=-=-=-=-=-= Get keyboard value --=-=-=-=-=-=-=-=-=-=-=

	mov	ah,1				        ; Get character from keyboard dos function
	int	21h					; Call dos function

;=-=-=-=-=-=- Check for time of day -=-=-=-=-=-=-=-=-=-=
	cmp	al,'y'					; check if input is y for yes						
	jz	ISAFTERNOON				; If the result is true zflag=1, therefore skip isafternoon
	cmp	al,'Y'					; check if input is Y for yes						
	jnz	ISAFTERNOON
	cmp	al,'n'					; check if input is n for no						
	jz	ISMORNING				; If the result is true zflag=1, therefore skip isafternoon
	cmp	al,'N'					; check if input is N for no						
	jnz	ISMORNING				;

;-=-=-=-=-=-=- Is morning function -=-=-=-=-=-=-=-=-=-=-
ISMORNING:
	mov	dx,offset GOODMORNMSG			; Point to morning msg 
	jmp	DISPLAYGREETING				;

;-=-=-=-=-=-=- Is afternoon function -=-=-=-=-=-=-=-=-=-=-

ISAFTERNOON:	
	mov	dx,offset GOODAFTNOON			; Point to afternoon msg 
	jmp	DISPLAYGREETING				;		

;-=-=-=-=-=-=- Is display greeting function -=-=-=-=-=-=-=-=-=-=-

DISPLAYGREETING:
	mov ah,09h				 	; use dos function write string to screen
	int 21h					        ; Call dos function
	

; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

