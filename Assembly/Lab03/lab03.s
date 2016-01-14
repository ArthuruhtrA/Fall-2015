            TTL CMPE 250 Lab 03
;****************************************************************
;Descriptive comment header goes here.
;(What does the program do?)
;Name:  Ari Sanders
;Date:  9/10/15
;Class:  CMPE-250
;Section:  04, Thursday, 4-5:50
;---------------------------------------------------------------
;Keil Simulator Template for KL46
;R. W. Melton
;January 23, 2015
;****************************************************************
;Assembler directives
            THUMB
            OPT    64  ;Turn on listing macro expansions
;****************************************************************
;EQUates
;Vectors
VECTOR_TABLE_SIZE EQU 0x000000C0
VECTOR_SIZE       EQU 4           ;Bytes per vector
;Stack
SSTACK_SIZE EQU  0x00000100
MULT2       EQU 1
MULT4       EQU 2
;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    MyCode,CODE,READONLY
            ENTRY
            EXPORT  Reset_Handler
Reset_Handler
main
;---------------------------------------------------------------
;>>>>> begin main program code <<<<<
;Fill registers from variables
            LDR     R1, =P
            LDR     R1, [R1, #0]
            LDR     R2, =Q
            LDR     R2, [R2, #0]
            LDR     R3, =R
            LDR     R3, [R3, #0]
			
			MOVS	R2, #128		;So we can use CMN
;F = 2P - 3Q + R + const_F
            LSLS    R0, R1, #MULT2  ;2P
			CMN		R0, R2
			BMI		STOP_F
			CMP		R0, #127
			BPL		STOP_F
			
            LSLS    R4, R2, #MULT2  ;2Q
			CMN		R4, R2
			BMI		STOP_F
			CMP		R4, #127
			BPL		STOP_F
			
            ADDS    R4, R4, R2      ;3Q
			CMN		R4, R2
			BMI		STOP_F
			CMP		R4, #127
			BPL		STOP_F
			
            SUBS    R0, R0, R4      ;-
			CMN		R0, R2
			BMI		STOP_F
			CMP		R0, #127
			BPL		STOP_F
			
            ADDS    R0, R0, R3      ;+ R
			CMN		R0, R2
			BMI		STOP_F
			CMP		R0, #127
			BPL		STOP_F
			
            ADDS    R0, R0, #const_F;+ const_F
			CMN		R0, R2
			BMI		STOP_F
			CMP		R0, #127
			BPL		STOP_F
			
            LDR     R4, =F
            STR     R0, [R4, #0]    ;Store value back to F

;G = 5P - 4Q - 2R + const_G
START_G
			LSLS    R0, R1, #MULT4  ;4P
            ADDS    R0, R0, R1      ;5P
            LSLS    R4, R2, #MULT4  ;4Q
            SUBS    R0, R0, R4      ;-
            LSLS    R4, R3, #MULT2  ;2R
            SUBS    R0, R0, R4      ;-
            ADDS    R0, R0, #const_G;+ const_G
            LDR     R4, =G
            STR     R0, [R4, #0]    ;Store value back to G
			
;H = P - 2Q + R - const_H
START_H
            LSLS    R0, R2, #MULT2  ;2Q
            SUBS    R0, R1, R2      ;P -
            ADDS    R0, R0, R3      ;+ R
            SUBS    R0, R0, #const_H;- const_H
            LDR     R4, =H
            STR     R0, [R4, #0]    ;Store value back to H
			
;Result = F + G + H
START_Result
            MOVS    R1, #G          ;G
            MOVS    R2, #F          ;F
            ADDS    R0, R0, R1      ;H + G
            ADDS    R0, R0, R2      ;+ F
            LDR     R4, =Result
            STR     R0, [R4, #0]    ;Store value back to Result
			
			B		.;Normal Stop

STOP_F		
            LDR     R4, =F
            STR     R0, [R4, #0]    ;Store value back to F
			B		START_G
STOP_G		
            LDR     R4, =G
            STR     R0, [R4, #0]    ;Store value back to F
			B		START_H
STOP_H		
            LDR     R4, =H
            STR     R0, [R4, #0]    ;Store value back to F
			B		START_Result

;>>>>>   end main program code <<<<<
;Stay here
            B       .
;---------------------------------------------------------------
;>>>>> begin subroutine code <<<<<
;>>>>>   end subroutine code <<<<<
            ALIGN
;****************************************************************
;Vector Table Mapped to Address 0 at Reset
;Linker requires __Vectors to be exported
            AREA    RESET, DATA, READONLY
            EXPORT  __Vectors
            EXPORT  __Vectors_End
            EXPORT  __Vectors_Size
__Vectors 
                                      ;ARM core vectors
            DCD    __initial_sp       ;00:end of stack
            DCD    Reset_Handler      ;reset vector
            SPACE  (VECTOR_TABLE_SIZE - (2 * VECTOR_SIZE))
__Vectors_End
__Vectors_Size  EQU     __Vectors_End - __Vectors
            ALIGN
;****************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;>>>>> begin constants here <<<<<
const_F     DCD     51
const_G     DCD     7
const_H     DCD     -91
;>>>>>   end constants here <<<<<
;****************************************************************
            AREA    |.ARM.__at_0x1FFFE000|,DATA,READWRITE,ALIGN=3
            EXPORT  __initial_sp
;Allocate system stack
            IF      :LNOT::DEF:SSTACK_SIZE
SSTACK_SIZE EQU     0x00000100
            ENDIF
Stack_Mem   SPACE   SSTACK_SIZE
__initial_sp
;****************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
F           SPACE   4
G           SPACE   4
H           SPACE   4
P           SPACE   4
Q           SPACE   4
R           SPACE   4
Result      SPACE   4
;>>>>>   end variables here <<<<<
            END