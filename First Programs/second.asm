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
        DW      100h    DUP(?) ;dw = define word.. all stack
			       ;are 16 bit, (?) initialises it	
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
    PUSH    DS	        ;must  always be at start of program
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX
    
ECHOLOOP: 
    	mov	ah,00h	;Dos keyboard input function
    	int	16h     ;Get the next key
    	cmp	al,13	;was the enter key pressed
    	jz	ECHODONE;yes were done echoing			
    	mov	dl,al	;put character into dl
    	mov     ah,2	;DOS display function
    	int     21h	;display the character 		
    	jmp     ECHOLOOP;echo the next character
ECHODONE:
	mov	ah,4CH	;DOS terminate program	    	
    	int     21h	;terminate the program




; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

