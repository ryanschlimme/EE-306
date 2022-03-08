; Ryan Schlimme
; 04 March 2022

; This program operates two 8-bit numbers located in x4000 and x4001. 
; The sum is stored in x4002 and the difference in x4003.
; The number in x4000 is assumed to be larger than that in x4001.

.ORIG x3000

LDI R0, NUM1;     load first number into register 0
LDI R1, NUM2;     load second number into register 1
LD R2, NUM3;      load bit mask into register 2

; MASK BITS [15:12], use AND
AND R0, R2, R0;   AND the first number and bit mask
AND R1, R2, R1;   AND the second number and bit mask

; SUM
ADD R3, R1, R0;   add the numbers and place sum in register 3
STI R3, NUM4;     store register 3 (sum) to memory using indirect addressing mode

; DIFFERENCE
NOT R1, R1;       one's complement the 2nd number loaded in register 1
ADD R1, R1, #1;   two's complement by adding 1 to the one's complement
ADD R4, R1, R0;   add the first number and the 2's complemented second number
STI R4, NUM5;     store register 4 (difference) to memory using indirect addressing mode

HALT

NUM1 .FILL x4000; address for first number
NUM2 .FILL x4001; address for second number
NUM3 .FILL x0FFF; bit mask to clear first four bits
NUM4 .FILL x4002; address for sum
NUM5 .FILL x4003; address for difference

.END