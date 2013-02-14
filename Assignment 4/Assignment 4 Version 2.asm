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
TEMP   DB 3 DUP(?)
WHOLE  DW 1 DUP(?)
PROMPT	db	13,10,'Enter a number between 0 and 9 : $'
ERROR	db	13,10,'You did not enter a number between 0 and 9 press enter to restart ! $'
RESULT	db	13,10,'The answer is : $'		

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
    MOV     BX,OFFSET WHOLE
    CMP     WHOLE,99
    JG      WRITETHREECHAR
    CMP     WHOLE,9
    JLE     WRITEONECHAR
    JG      WRITETWOCHAR
WRITEONECHAR:
    CALL    WRITEONECHARS
    JMP     CONTINUE2
WRITETWOCHAR:    
    CALL    WRITETWOCHARS
    JMP     CONTINUE2
WRITETHREECHAR: 
    CALL    WRITETHREECHARS
    JMP     CONTINUE2
CONTINUE2:    
    CALL    CLOSE
ERRORTRAP:    
    MOV     DX,OFFSET ERROR
    CALL    WRITESTRING
    CALL    READKEY
    JMP     MAIN
    
; return to operating system:
    RET
START   ENDP

;=-=-=-=-=-=-=-=-=- Write A 3 Decimal (111-999) Numbers To Screen =-=-=-=-=-=-=-=-=-=-
WRITETHREECHARS PROC
    MOV     AX,[BX]
    MOV     BX,OFFSET TEMP
    ADD     BX,2
    MOV     DL,10
    DIV     DL
    MOV     [BX],AH
    DEC     BX
    MOV     AH,0
    DIV     DL
    MOV     [BX],AH
    DEC	    BX
    MOV     AH,0
    DIV     DL
    MOV     [BX],AH
    MOV     BX,OFFSET TEMP
    MOV     DL,[BX]
    CALL    CHARWRITE
    INC     BX
    MOV     DL,[BX]
    CALL    CHARWRITE
    INC     BX
    MOV     DL,[BX]
    CALL    CHARWRITE
    RET
WRITETHREECHARS ENDP    

;=-=-=-=-=-=-=-=-=- Write A Two Decimal (11-99) Number To Screen =-=-=-=-=-=-=-=-=-=-
WRITETWOCHARS PROC
    MOV     AX,[BX]
    MOV     DL,10
    DIV     DL
    MOV     CX,AX
    MOV     DL,CL
    CALL    CHARWRITE
    MOV     DL,CH
    CALL    CHARWRITE 
    RET
WRITETWOCHARS ENDP    

;=-=-=-=-=-=-=-=-=- Write A Single Decimal Number To Screen =-=-=-=-=-=-=-=-=-=-
WRITEONECHARS PROC
    MOV     DL,[BX]
    CALL    CHARWRITE
    RET
WRITEONECHARS ENDP    

;=-=-=-=-=-=-=-=-=- Calculate Cube Function - Put Value into DX =-=-=-=-=-=-=-=-=-=-
CUBEROOT    PROC
    MOV     AH,0
    MUL     DL
    MUL     DL
    MOV     DL,5
    DIV     DL
    MOV     BX,OFFSET WHOLE
    MOV     [BX],AL
    MOV     AL,AH
    MOV     AH,0
    MOV     DL,2
    MUL     DL
    CMP     AL,5
    JGE     ROUNDUP
    JL      ROUNDDOWN
ROUNDUP:
    INC     [BX]	
ROUNDDOWN:    
    NOP
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

