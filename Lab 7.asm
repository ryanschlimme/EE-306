; Ryan Schlimme
; 19 April 2022

; This program prints the message "Waiting for user input...\n" with delay logic until a button is 
; pressed on the keyboard. Then, it tests to see whether the button is a letter, a number, or q/Q. 
; It prints the appropriate response and continues the infinite loop unless q/Q was pressed when it
; prints the appropriate response and halts the program.

; OPERATING SYSTEM CODE

.ORIG x500
        
        LD R0, VEC
        LD R1, ISR
        ; (1) Initialize interrupt vector table with the starting address of ISR.
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR. [To Enable Interrupt]
        LD R2, KBSR
        LDR R3, R2, #0
        NOT R3, R3
        LD R4, MASK
        AND R4, R4, R3
        NOT R4, R4
        STR R4, R2, #0
	
        ; (3) Set up system stack to enter user space. So that PC can return to the main user program at x3000.
	    ; R6 is the Stack Pointer. Remember to Push PC and PSR in the right order. Hint: Refer State Graph
        LD R4, PSR
        ADD R6, R6, #-1
        STR R4, R6, #0
        LD R4, PC
        ADD R6, R6, #-1
        STR R4, R6, #0
        
        ; (4) Enter user Program.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1700
KBSR    .FILL xFE00
MASK    .FILL xBFFF
PSR     .FILL x8002
PC      .FILL x3000

.END


; INTERRUPT SERVICE ROUTINE

.ORIG x1700
ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R4, SAVER4
ST R5, SAVER5
ST R7, SAVER7

; CHECK THE KIND OF CHARACTER TYPED AND PRINT THE APPROPRIATE PROMPT
LD R0, KBDRPtr
LDR R0, R0, #0
LD R1, ASCII_qLC
ADD R2, R0, R1
BRz QUIT
LD R1, ASCII_QUC
ADD R2, R0, R1
BRz QUIT

CONTINUE
LD R1, ASCII_NUM_Low
ADD R2, R0, R1
BRn Invalid_Input
BRz Number_Detected
LD R1, ASCII_NUM_High
ADD R2, R0, R1
BRnz Number_Detected

LD R1, ASCII_UC_Low
ADD R2, R0, R1
BRn Invalid_Input
BRz Alphabet_Detected
LD R1, ASCII_UC_High
ADD R2, R0, R1
BRnz Alphabet_Detected

LD R1, ASCII_LC_Low
ADD R2, R0, R1
BRn Invalid_Input
BRz Alphabet_Detected
LD R1, ASCII_LC_High
ADD R2, R0, R1
BRnz Alphabet_Detected
BRp Invalid_Input

QUIT
LEA R2, STRING4
LDR R0, R2, #0

POLL1   LDI R1, DSRPtr
        BRzp POLL1
        STI  R0, DDRPtr
        ADD R2, R2, #1
        LDR R0, R2, #0
        BRnp POLL1
HALT

Number_Detected
LEA R2, STRING2
LDR R0, R2, #0

POLL2   LDI R1, DSRPtr
        BRzp POLL2
        STI  R0, DDRPtr
        ADD R2, R2, #1
        LDR R0, R2, #0
        BRnp POLL2
BRnzp ending

Invalid_Input
LEA R2, STRING3
LDR R0, R2, #0

POLL3   LDI R1, DSRPtr
        BRzp POLL3
        STI  R0, DDRPtr
        ADD R2, R2, #1
        LDR R0, R2, #0
        BRnp POLL3
BRnzp ending

Alphabet_Detected
LEA R2, STRING1
LDR R0, R2, #0

POLL4   LDI R1, DSRPtr
        BRzp POLL4
        STI  R0, DDRPtr
        ADD R2, R2, #1
        LDR R0, R2, #0
        BRnp POLL4

ending  LD R0, SAVER0
        LD R1, SAVER1
        LD R2, SAVER2
        LD R3, SAVER3 
        LD R4, SAVER4
        LD R5, SAVER5
        LD R7, SAVER7
    RTI

ASCII_NUM_Low .FILL x-30
ASCII_NUM_High .FILL x-39
ASCII_LC_Low  .FILL x-61
ASCII_LC_High .FILL x-7A
ASCII_UC_Low  .FILL x-41
ASCII_UC_High .FILL x-5A
ASCII_qLC   .FILL x-71
ASCII_QUC   .FILL x-51
KBSRPtr .FILL xFE00
KBDRPtr .FILL xFE02
DSRPtr .FILL xFE04
DDRPtr .FILL xFE06
SAVER0 .BLKW x1
SAVER1 .BLKW x1
SAVER2 .BLKW x1
SAVER3 .BLKW x1
SAVER4 .BLKW x1
SAVER5 .BLKW x1
SAVER7 .BLKW x1
STRING1 .STRINGZ "\nSuccess! An alphabet letter was detected.\n"
STRING2 .STRINGZ "\nSuccess! A number was detected.\n"
STRING3 .STRINGZ "\nERROR: The inputted character is invalid.\n"
STRING4 .STRINGZ "\n---------- User has Quit the Program ----------\n"
.END


; USER PROGRAM
.ORIG x3000

; MAIN USER PROGRAM
; PRINT THE MESSAGE "Waiting for user input…" WITH A DELAY LOGIC

OUTLoop LD R1, Delay
LEA R0, MESSAGE
PUTS
DELAYLoop ADD R1, R1, #-1
BRnp DELAYLoop
BRz OUTLoop

CNT .FILL xFFFF
MESSAGE .STRINGZ  "Waiting for user input...\n"
Delay .FILL xFFFF
.END
