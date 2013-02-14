TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

PROMPT	db	13,10,'Please enter a number : $'
INPUT	db	20 DUP(?)
XFLAG	db	1 DUP(?)
NEWLINE	db      13,10,'$'
COUNT   db      1 DUP(?)

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
    MOV     CL,0	; Set Counter to 0
    MOV     CX,0	; Set Counter to 0

;==-=-=-=-Display Get number prompt and get number from keyboard-=-=-=-=-=-=-=-=-=-=-=-
;= This Function will take the input and convert it to decimal (weighted number)      =
;= to allow for compare instruction to be used. It also allows for a single number to =
;= be entered by entering the number and pressing enter				      =
;======================================================================================
MAIN:
    MOV     DX,OFFSET PROMPT		; Load Prompt Address
    CALL    WRITESTRING			; Write Prompt asking for number to screen
    CALL    READKEY			; Read Character from keyboard
    SUB	    AL,30h			; Convert asci value to number (-30h or -48)
    PUSH    AX				; Save the entered number to temp area
    CALL    READKEY			; Read key again
    CMP     AL,13			; Check if enter key was pressed
    JE	    SKIPCHAR2			; If enter key was pressed skip second character
    SUB	    AL,30h			; convert asci value to number
    MOV     DL,AL			; Move the received value
    POP	    AX				; Move Value first entered from stack
    MOV	    BL,10			; 
    MUL     BL				; Save the value as a tens number
    ADD	    DL,AL			; Add the values together to get full number
    JMP	    CARRYON	
SKIPCHAR2:
    POP     AX				; Move temp value back
    MOV	    DL,AL			; 
CARRYON:
    MOV     BX,OFFSET INPUT		; Save the inputs to a memory location
    ADD	    BL,CL		        ; Add counter to the memory location to get correct location    
    MOV     [BX],DL			;   
    INC	    CL				;
    CMP     CL,10			; Check if ten chars have been entered
    JNE	    MAIN    		        ; If not go and get a char again	
    MOV     BX,OFFSET INPUT		; Load Input Address
    MOV     CX,0			;
    MOV     CL,0			;
    CALL    BUBBLE			;    
    MOV	    CX,0			;
    MOV     CL,0			;
    CALL    LINENEW
    CALL    DISPLAY			;
    MOV     AH,4Ch			;
    INT	    21h				;

START    ENDP

BUBBLE  PROC
AGAIN:    
    MOV     AL,[BX]			;SWAP the values
    MOV	    AH,[BX+1]			;
    INC	    CX
    CMP     AL,AH			;
    JG	    SWAP			; If element > element + 1 swap them
    JLE     NOTHING			; Don't do jack to numbers	
SWAP:
    MOV     AL,[BX]			;SWAP the values
    MOV	    AH,[BX+1]			;
    MOV     [BX+1],AL	    		;Write them back to memory
    MOV     [BX],AH			;
    MOV     XFLAG,1			;SET the change flag
NOTHING:
    INC     BX				;
    CMP     CX,09h			;
    JNE     AGAIN			;
    CMP     XFLAG,0			;If the Xflag is 1 an exchange occured
    JE      EXIT	
    MOV     CX,0			;
    MOV     BX, OFFSET INPUT
    MOV     XFLAG,0			;
    JMP	    AGAIN			;If xflag is 0 then stop sorting	  	    
EXIT:    
    RET	
BUBBLE  ENDP

DISPLAY PROC
    MOV     BX,OFFSET INPUT
    CALL    LINENEW
AGAINS:
    MOV     DL,20h
    CALL    WRITECHAR
    MOV     AX,[BX]
    MOV     AH,0
    MOV     DL,10
    DIV     DL
    MOV     CX,AX
    MOV	    DL,CL	
    ADD     DL,30h
    CALL    WRITECHAR
    MOV     DL,CH
    ADD     DL,30h
    CALL    WRITECHAR
    INC     BX
    INC	    COUNT
    CMP     COUNT,10
    JNE     AGAINS    
    RET	
DISPLAY ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write Character from keyboard =-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
WRITECHAR PROC

    MOV	    AH,02h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
WRITECHAR ENDP


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

