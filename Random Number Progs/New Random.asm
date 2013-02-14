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

    MOV     BH,5          ; Set BX to number if random nums required
    MOV     BL,0          ; Counts the number of numbers entered
REDO:
    CALL    READKEY
    CMP     AL,13h        ; Check if enter was pressed
    JE      REDO
    MOV	    AH,00h	  ; Call the System Time Function
    INT	    1Ah		  ; //
    MOV	    AL,00000111b  ; Take the Recieved Time Value and remove the 128 and 32 bits
    AND	    AL,DL	  ; to make sure the value is less than 99 (Actually 95)
    INC     BL
    CMP     BL,BH
    JE      EXIT
    MOV     DL,AL	  ; Write Number to Screen
    CALL    CHARWRITE
    JNE     REDO          ; Keep Looping till counter = number of need random nums
EXIT:    
; return to operating system:
    RET
START   ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Write Character to screen (Converts to Asci)-=-=-=-=-=-=-=-=-=    	
CHARWRITE PROC

    ADD     DL,30h                      ; Convert from Decimal to asci
    MOV	    AH,02h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
CHARWRITE ENDP

;-=-=-=-=-=-=-=-=-=-=-=-=-=-Read Character from keyboard =-=-=-=-=-=-=-=-=-=-=-=-=-=-=    	
READKEY PROC

    MOV	    AH,01h			; Call the dos function to write a char string	
    INT	    21h				; to the screen using interupt 21h
    RET
    
READKEY ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

