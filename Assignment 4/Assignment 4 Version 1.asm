TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

NEWLINE:
	db      13,10
	db	'$'

WHOLE  DW 1 DUP(?)

COUNT  DB 1 DUP(?)

PROMPT: 
	db	13,10,'Enter a number between 0 and 9 : $'

ERROR: 
	db	13,10,'You did not enter a number between 0 and 9 press enter to restart ! $'

RESULT:
	db	13,10,'The answer is : $'		
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
MAIN:
    MOV     DX,OFFSET PROMPT
    CALL    WRITESTRING
    CALL    READKEY
    CMP     AL,30h
    JL      ERRORTRAP
    CMP     AL,39h
    JG      ERRORTRAP
    SUB     AL,30h				; Convert from Asci to Decimal
    MOV     DL,AL                               ; Get Decimal value ready for cube root procedure
    CALL    CUBEROOT				; Terminate the program
    MOV     DX,OFFSET RESULT
    CALL    WRITESTRING
    MOV     DL,[BX]
    CALL    CHARWRITE
    CALL    CLOSE
ERRORTRAP:    
    MOV     DX,OFFSET ERROR
    CALL    WRITESTRING
    CALL    READKEY
    JMP     MAIN
    
; return to operating system:
    RET
START   ENDP

;=-=-=-=-=-=-=-=-=- Calculate Cube Function - Put Value into DX =-=-=-=-=-=-=-=-=-=-
CUBEROOT    PROC
    MOV     CX,0
    MOV     BX,OFFSET COUNT
LOOP1:
    MOV     AX,CX				; Multiply to see if you get the cube of answer
    MUL     CL					; Cube of 0 = 0 * 0 * 0
    MUL     CL	
    CMP     AX,DX         		        ; If the number to be cubed = 3 * counter thats the answer	   	    	     
    JG      CLOSETOANSWER
    INC     CX
    INC     [BX]
    JMP     LOOP1
CLOSETOANSWER: 
    DIV     CL                                  ; Cause the multiplied answer is to big we need to back track
    DIV     CL                                  ; Divide AX twice to get to the nearest whole number
    MOV     BX,OFFSET WHOLE			; Answer is below the number in whole ie. Cube root 2 = 1.25 therefore whole = 2
    MOV     [BX],AX
    CMP     [BX],4
    JL      ANSWERIS0
    JE      ANSWERIS1
ANSWERIS1:
    MOV     [BX],1	
    JMP     CONTINUE
ANSWERIS0:
    MOV     [BX],0
CONTINUE:
    RET
CUBEROOT    ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write Character to screen (Converts to Asci)-=-=-=-=-=-=-=-=-=    	
CHARWRITE PROC

    ADD     DL,30h                      ; Convert from Decimal to asci
    MOV	    AH,02h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
CHARWRITE ENDP

;=-=-=-=-=-=-=-=-=-=-=-=-=-Terminate Program-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
CLOSE       PROC
    MOV	    AH, 4Ch			; Call dos function to terminate program using		 
    INT	    21h				; Interrupt 21h
CLOSE       ENDP

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



;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

