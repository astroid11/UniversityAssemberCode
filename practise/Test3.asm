TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

INPUT db 5 DUP(?)
ONE db 13,10,'Welcome to Practical Test 2 Program $'
TWO db 13,10,'Press the Enter Key five times to generate five random numbers $'
THREE db 13,10,'Square of random numbers : $'
FOUR db 13,10,'Numbers are now sorted: $'
FIVE db 13,10,'Press the enter key to quit program $'
XFLAG   db 1 DUP(?)
NEWLINE db 13,10,'$'
TEMP    db 1 DUP(?)
COUNT    db 1 DUP(?)

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

;Get Five Random Numbers
    MOV     DX,OFFSET ONE
    CALL    WRITESTRING
    MOV     DX,OFFSET TWO
    CALL    WRITESTRING
    MOV     CX,0
    MOV     BX,OFFSET INPUT
    CALL    RANDNUM
    CALL    DISPLAY
    CALL    LINENEW

;Get the square of the numbers
    MOV     DX,OFFSET THREE
    CALL    WRITESTRING
    MOV     COUNT,0
    MOV     BX,OFFSET INPUT
READ5:    
    MOV     AL,[BX]
    CALL    SQR
    MOV     [BX],AL
    INC     BX
    INC     COUNT
    CMP     COUNT,5
    JNE     READ5
    CALL    DISPLAY

; Sort the numbers    
    CALL    LINENEW
    MOV     CX,0
    MOV     BX,OFFSET INPUT
    MOV     DX,OFFSET FOUR
    CALL    WRITESTRING
    CALL    BUBBLE
    CALL    DISPLAY
    
; Exit prompt, wait for a key    
    CALL    LINENEW
    MOV     DX,OFFSET FIVE     
    CALL    WRITESTRING
    CALL    READKEY

; return to operating system:
    RET
START   ENDP

;-=-=-=-=-=-=-=-=-=- Gets a random number from the system ticker ==-=-=-=-=-=-
; (Requires Readkey Function to Work!!!! .... )
; ( CL -> Counter fo program, AH,AL,Dl,CL)

RANDNUM PROC
    MOV     COUNT,0
REDO:
    CALL    READKEY
    CMP     AL,13h        ; Check if enter was pressed
    JE      REDO
    MOV	    AH,00h	  ; Call the System Time Function
    INT	    1Ah		  ; //
    MOV	    AL,00000111b  ; Take the Recieved Time Value and remove the 128 and 32 bits
    AND	    AL,DL	  ; to make sure the value is less than 99 (Actually 95)
    ADD     AL,2	  ;
    MOV     [BX],AL
    INC     BX
    INC     COUNT
    CMP     COUNT,5          ; Set this to equal the number of random number needed
    JE      EXIT
    JMP     REDO
    RET
RANDNUM ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write Character to screen -=-=-=-=-=-=-=-=-=    	
;(Uses AX)
WRITECHAR PROC

    MOV	    AH,02h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
WRITECHAR ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Read Character from keyboard =-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
READKEY PROC
; (Uses AH and DL)
    MOV	    AH,01h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
READKEY ENDP

;-=--=-=-=-=-=-=-=-=-=-=-=-= Bubble Sort Function -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; (Version 2 -> Doesn't Crash when to numbers that are same are sorted
; (Uses BX and CX)
BUBBLE  PROC
AGAIN:    
    MOV     AL,[BX]			;SWAP the values
    MOV	    AH,[BX+1]			;
    INC	    CX
    CMP     AL,AH			;
    JG	    SWAP			; If element > element + 1 swap them
    JLE     NOTHING			; Don't do jack to numbers
                  			;(Swapping the above statements changes sorting ASC DEC etc)	
SWAP:
    MOV     AL,[BX]			;SWAP the values
    MOV	    AH,[BX+1]			;
    MOV     [BX+1],AL	    		;Write them back to memory
    MOV     [BX],AH			;
    MOV     XFLAG,1			;SET the change flag
NOTHING:
    INC     BX				;
    CMP     CX,4			;
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

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write String to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
; ( Put String to write OFFSET into DX)
WRITESTRING PROC
    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
WRITESTRING ENDP
;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write New Line to Screen Function-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
; (uses AX, DL)
LINENEW PROC

    MOV	    DX,OFFSET NEWLINE
    MOV	    AH,09h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
LINENEW ENDP

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
    ADD     DL,30h
    CALL    WRITECHAR
    INC     BX
    MOV     DL,[BX]
    ADD     DL,30h
    CALL    WRITECHAR
    INC     BX
    MOV     DL,[BX]
    ADD     DL,30h
    CALL    WRITECHAR
    RET
WRITETHREECHARS ENDP    

;=-=-=-=-=-=-=-=-=- Write A Two Decimal (11-99) Number To Screen =-=-=-=-=-=-=-=-=-=-
WRITETWOCHARS PROC
    MOV     AX,[BX]
    MOV     DL,10
    DIV     DL
    MOV     CX,AX
    MOV     DL,CL
    ADD     DL,30h
    CALL    WRITECHAR
    MOV     DL,CH
    ADD     DL,30h
    CALL    WRITECHAR
    RET
WRITETWOCHARS ENDP    

;=-=-=-=-=-=-=-=-=- Write A Single Decimal Number To Screen =-=-=-=-=-=-=-=-=-=-
WRITEONECHARS PROC
    MOV     DL,[BX]
    ADD     DL,30h
    CALL    WRITECHAR
    RET
WRITEONECHARS ENDP    

;=-=-=-=-=-=-=-=-=- Calculate Cube Function=-=-=-=-=-=-=-=-=-=-
;(Put Value to Cube in AL, CLEARS AH! Answer in AL)
CUBE PROC
    MOV     AH,0
    MOV     DL,AL
    MUL     DL
    MUL     DL
    RET	
CUBE ENDP

;=-=-=-=-=-=-=-=-=- Calculate Square Function =-=-=-=-=-=-=-=-=-=-
;(Put Value to Cube in AL, CLEARS AH! Answer in AL)
SQR  PROC
    MOV     AH,0
    MOV     DL,AL
    MUL     DL
    RET	
SQR  ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=- Writes Decimal Numbers stored in array -=-=-=-=-=-=-=-=-=-
; ( Handles One to Digit Numbers)

DISPLAY PROC
    MOV     COUNT,0
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
    CMP     COUNT,5
    JNE     AGAINS    
    RET	
DISPLAY ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

