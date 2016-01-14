            TTL CMPE 250 Lab 04
;****************************************************************
;Descriptive comment header goes here.
;(What does the program do?)
;Name:  Ari Sanders
;Date:  <Date completed here>
;Class:  CMPE-250
;Section:  L4 Thursday 4-5:50
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
    
MAX_DATA    EQU  25
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
            BL      InitData
Load            
            BL      LoadData
            BCS     .
            BL      DIVU
            BCC     Continue
            LDR     R0, =0xFFFFFFFF ;Load 0xFs to R0
            LDR     R1, =P          ;Store R0 to P
            STR     R0, [R1, #0]
            LDR     R1, =Q          ;Also to Q
            STR     R0, [R1, #0]
Continue
            BL      TestData
            B       Load
;>>>>>   end main program code <<<<<
;Stay here
            B       .
;---------------------------------------------------------------
;>>>>> begin subroutine code <<<<<
DIVU
            CMP	    R0, #0      ;Check if R0=0
            BNE	    DIVU_NZ     ;If not, branch to NZ
            PUSH    {R0}          ;Set C
            PUSH    {R1}
            MRS     R0, APSR
            MOVS    R1, #0x20
            LSLS    R1, R1, #24
            ORRS    R0, R0, R1
            MSR     APSR, R0
            POP     {R1}
            POP     {R0}
            B       DIVU_Return ;Return
DIVU_NZ		                    ;NZ
            PUSH    {R2}        ;Push R2 onto stack
            MOV     R2, R0      ;MOV R0->R2
DIVU_Loop                       ;Loop
            CMP     R1, R2      ;Check R1 >= R2
            BLO     DIVU_EndLoop     ;If not, branch to EndLoop
            SUBS    R1, R1, R2  ;R1 -= R2
            ADDS    R0, R0, #1  ;R0 ++
            B       DIVU_Loop   ;Branch to Loop
DIVU_EndLoop                   ;EndLoop
            PUSH    {R0}          ;Clear C
            PUSH    {R1}
            MRS     R0, APSR
            MOVS    R1, #0x20
            LSLS    R1, R1, #24
            BICS    R0, R0, R1
            MSR     APSR, R0
            POP     {R1}
            POP     {R0}
            POP     {R2}        ;Pop R2 off stack
DIVU_Return
            BX      LR          ;Return       
;>>>>>   end subroutine code <<<<<
            ALIGN
;**************************************************************** 
;****************************************************************
;Machine code provided for Exercise Four
;R. W. Melton 9/14/2015
;Place at the end of your MyCode AREA
            AREA    |.ARM.__at_0x4000|,CODE,READONLY
InitData    DCI.W   0x26002700
            DCI     0x4770
LoadData    DCI.W   0xB40FA316
            DCI.W   0x19DBA13D
            DCI.W   0x428BD209
            DCI.W   0xCB034A10
            DCI.W   0x4B116010
            DCI.W   0x60193708
            DCI.W   0x20000840
            DCI.W   0xBC0F4770
            DCI.W   0x20010840
            DCI     0xE7FA
TestData    DCI.W   0xB40F480C
            DCI.W   0xA13419C0
            DCI.W   0x19C93808
            DCI.W   0x39084A07
            DCI.W   0x4B076812
            DCI.W   0x681BC00C
            DCI.W   0x68084290
            DCI.W   0xD1046848
            DCI.W   0x4298D101
            DCI.W   0xBC0F4770
            DCI.W   0x1C76E7FB
            ALIGN
PPtr        DCD     P
QPtr        DCD     Q
ResultsPtr  DCD     Results
            DCQ     0x0000000000000000,0x0000000000000001
            DCQ     0x0000000100000000,0x0000000100000010
            DCQ     0x0000000200000010,0x0000000400000010
            DCQ     0x0000000800000010,0x0000001000000010
            DCQ     0x0000002000000010,0x0000000100000007
            DCQ     0x0000000200000007,0x0000000300000007
            DCQ     0x0000000400000007,0x0000000500000007
            DCQ     0x0000000600000007,0x0000000700000007
            DCQ     0x0000000800000007,0x8000000080000000
            DCQ     0x8000000180000000,0x000F0000FFFFFFFF
            DCQ     0xFFFFFFFFFFFFFFFF,0xFFFFFFFFFFFFFFFF
            DCQ     0x0000000000000000,0x0000000000000010
            DCQ     0x0000000000000008,0x0000000000000004
            DCQ     0x0000000000000002,0x0000000000000001
            DCQ     0x0000001000000000,0x0000000000000007
            DCQ     0x0000000100000003,0x0000000100000002
            DCQ     0x0000000300000001,0x0000000200000001
            DCQ     0x0000000100000001,0x0000000000000001
            DCQ     0x0000000700000000,0x0000000000000001
            DCQ     0x8000000000000000,0x0000FFFF00001111
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
P           SPACE   4     
Q           SPACE   4     
Results     SPACE   4 * 2 * MAX_DATA
;>>>>>   end variables here <<<<<
            END