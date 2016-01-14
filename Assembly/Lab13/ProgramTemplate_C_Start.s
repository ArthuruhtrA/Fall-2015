            TTL CMPE 250 Lab 12
;****************************************************************
;Provides subroutines and constants for C program in assembly
;Name:  Ari Sanders
;Date:  11/30/2015
;Class:  CMPE-250
;Section:  Lab 04, 1600-17:50 Thursdays
;---------------------------------------------------------------
;Keil Template for KL46 Assembly with Keil C startup
;R. W. Melton
;April 20, 2015
;****************************************************************
;Assembler directives
            THUMB
            GBLL  MIXED_ASM_C
MIXED_ASM_C SETL  {TRUE}
            OPT   64  ;Turn on listing macro expansions
;****************************************************************
;Include files
            GET  MKL46Z4.s     ;Included by start.s
            OPT  1   ;Turn on listing
;****************************************************************
;EQUates
;---------------------------------------------------------------
;From Professor Melton
;***********************
;Characters
BS          EQU  0x08
CR          EQU  0x0D
DEL         EQU  0x7F
ESC         EQU  0x1B
LF          EQU  0x0A
NULL        EQU  0x00
;***********************
;Strings
MAX_STRING  EQU  79
;***********************
; Queue management record field offsets
IN_PTR      EQU   0
OUT_PTR     EQU   4
BUF_STRT    EQU   8
BUF_PAST    EQU   12
BUF_SIZE    EQU   16
NUM_ENQD    EQU   17
; Queue structure sizes
Q_BUF_SZ    EQU   4   ;Queue contents
Q_REC_SZ    EQU   18  ;Queue management record
; Tx/Rx Queue structure sizes (Mine)
XQ_BUF_SZ    EQU   80   ;Queue contents
; Queue delimiters for printed output
Q_BEGIN_CH  EQU   '>'
Q_END_CH    EQU   '<'

;For Lab 13
;---------------------------------------------------------------
;NVIC_ICER
;31-00:CLRENA=masks for HW IRQ sources;
;             read:   0 = unmasked;   1 = masked
;             write:  0 = no effect;  1 = mask
;22:PIT IRQ mask
;12:UART0 IRQ mask
NVIC_ICER_PIT_MASK    EQU  PIT_IRQ_MASK
NVIC_ICER_UART0_MASK  EQU  UART0_IRQ_MASK
;---------------------------------------------------------------
;NVIC_ICPR
;31-00:CLRPEND=pending status for HW IRQ sources;
;             read:   0 = not pending;  1 = pending
;             write:  0 = no effect;
;                     1 = change status to not pending
;22:PIT IRQ pending status
;12:UART0 IRQ pending status
NVIC_ICPR_PIT_MASK    EQU  PIT_IRQ_MASK
NVIC_ICPR_UART0_MASK  EQU  UART0_IRQ_MASK
;---------------------------------------------------------------
;NVIC_IPR0-NVIC_IPR7
;2-bit priority:  00 = highest; 11 = lowest
;--PIT
PIT_IRQ_PRIORITY    EQU  0
NVIC_IPR_PIT_MASK   EQU  (3 << PIT_PRI_POS)
NVIC_IPR_PIT_PRI_0  EQU  (PIT_IRQ_PRIORITY << UART0_PRI_POS)
;--UART0
UART0_IRQ_PRIORITY    EQU  3
NVIC_IPR_UART0_MASK   EQU (3 << UART0_PRI_POS)
NVIC_IPR_UART0_PRI_3  EQU (UART0_IRQ_PRIORITY << UART0_PRI_POS)
;---------------------------------------------------------------
;NVIC_ISER
;31-00:SETENA=masks for HW IRQ sources;
;             read:   0 = masked;     1 = unmasked
;             write:  0 = no effect;  1 = unmask
;22:PIT IRQ mask
;12:UART0 IRQ mask
NVIC_ISER_PIT_MASK    EQU  PIT_IRQ_MASK
NVIC_ISER_UART0_MASK  EQU  UART0_IRQ_MASK
;---------------------------------------------------------------
;PIT_LDVALn:  PIT load value register n
;31-00:TSV=timer start value (period in clock cycles - 1)
;Clock ticks for 0.01 s at 24 MHz count rate
;0.01 s * 24,000,000 Hz = 240,000
;TSV = 240,000 - 1
PIT_LDVAL_10ms  EQU  239999
;---------------------------------------------------------------
;PIT_MCR:  PIT module control register
;1-->    0:FRZ=freeze (continue'/stop in debug mode)
;0-->    1:MDIS=module disable (PIT section)
;               RTI timer not affected
;               must be enabled before any other PIT setup
PIT_MCR_EN_FRZ  EQU  PIT_MCR_FRZ_MASK
;---------------------------------------------------------------
;PIT_TCTRLn:  PIT timer control register n
;0-->   2:CHN=chain mode (enable)
;1-->   1:TIE=timer interrupt enable
;1-->   0:TEN=timer enable
PIT_TCTRL_CH_IE  EQU  (PIT_TCTRL_TEN_MASK :OR: PIT_TCTRL_TIE_MASK)
;---------------------------------------------------------------
;PORTx_PCRn (Port x pin control register n [for pin n])
;___->10-08:Pin mux control (select 0 to 8)
;Use provided PORT_PCR_MUX_SELECT_2_MASK
;---------------------------------------------------------------
;Port A
PORT_PCR_SET_PTA1_UART0_RX  EQU  (PORT_PCR_ISF_MASK :OR: \
                                  PORT_PCR_MUX_SELECT_2_MASK)
PORT_PCR_SET_PTA2_UART0_TX  EQU  (PORT_PCR_ISF_MASK :OR: \
                                  PORT_PCR_MUX_SELECT_2_MASK)
;---------------------------------------------------------------
;SIM_SCGC4
;1->10:UART0 clock gate control (enabled)
;Use provided SIM_SCGC4_UART0_MASK
;---------------------------------------------------------------
;SIM_SCGC5
;1->09:Port A clock gate control (enabled)
;Use provided SIM_SCGC5_PORTA_MASK
;---------------------------------------------------------------
;SIM_SOPT2
;01=27-26:UART0SRC=UART0 clock source select
;         (PLLFLLSEL determines MCGFLLCLK' or MCGPLLCLK/2)
; 1=   16:PLLFLLSEL=PLL/FLL clock select (MCGPLLCLK/2)
SIM_SOPT2_UART0SRC_MCGPLLCLK  EQU  \
                                 (1 << SIM_SOPT2_UART0SRC_SHIFT)
SIM_SOPT2_UART0_MCGPLLCLK_DIV2 EQU \
    (SIM_SOPT2_UART0SRC_MCGPLLCLK :OR: SIM_SOPT2_PLLFLLSEL_MASK)
;---------------------------------------------------------------
;SIM_SOPT5
; 0->   16:UART0 open drain enable (disabled)
; 0->   02:UART0 receive data select (UART0_RX)
;00->01-00:UART0 transmit data select source (UART0_TX)
SIM_SOPT5_UART0_EXTERN_MASK_CLEAR  EQU  \
                               (SIM_SOPT5_UART0ODE_MASK :OR: \
                                SIM_SOPT5_UART0RXSRC_MASK :OR: \
                                SIM_SOPT5_UART0TXSRC_MASK)
;---------------------------------------------------------------
;UART0_BDH
;    0->  7:LIN break detect IE (disabled)
;    0->  6:RxD input active edge IE (disabled)
;    0->  5:Stop bit number select (1)
;00001->4-0:SBR[12:0] (UART0CLK / [9600 * (OSR + 1)]) 
;UART0CLK is MCGPLLCLK/2
;MCGPLLCLK is 96 MHz
;MCGPLLCLK/2 is 48 MHz
;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
UART0_BDH_9600  EQU  0x01
;---------------------------------------------------------------
;UART0_BDL
;26->7-0:SBR[7:0] (UART0CLK / [9600 * (OSR + 1)])
;UART0CLK is MCGPLLCLK/2
;MCGPLLCLK is 96 MHz
;MCGPLLCLK/2 is 48 MHz
;SBR = 48 MHz / (9600 * 16) = 312.5 --> 312 = 0x138
UART0_BDL_9600  EQU  0x38
;---------------------------------------------------------------
;UART0_C1
;0-->7:LOOPS=loops select (normal)
;0-->6:DOZEEN=doze enable (disabled)
;0-->5:RSRC=receiver source select (internal--no effect LOOPS=0)
;0-->4:M=9- or 8-bit mode select 
;        (1 start, 8 data [lsb first], 1 stop)
;0-->3:WAKE=receiver wakeup method select (idle)
;0-->2:IDLE=idle line type select (idle begins after start bit)
;0-->1:PE=parity enable (disabled)
;0-->0:PT=parity type (even parity--no effect PE=0)
UART0_C1_8N1  EQU  0x00
;---------------------------------------------------------------
;UART0_C2
;0-->7:TIE=transmit IE for TDRE (disabled)
;0-->6:TCIE=transmission complete IE for TC (disabled)
;0-->5:RIE=receiver IE for RDRF (disabled)
;0-->4:ILIE=idle line IE for IDLE (disabled)
;1-->3:TE=transmitter enable (enabled)
;1-->2:RE=receiver enable (enabled)
;0-->1:RWU=receiver wakeup control (normal)
;0-->0:SBK=send break (disabled, normal)
UART0_C2_T_R    EQU  (UART0_C2_TE_MASK :OR: UART0_C2_RE_MASK)
UART0_C2_T_RI   EQU  (UART0_C2_RIE_MASK :OR: UART0_C2_T_R)
UART0_C2_TI_RI  EQU  (UART0_C2_TIE_MASK :OR: UART0_C2_T_RI)
;---------------------------------------------------------------
;UART0_C3
;0-->7:R8T9=9th data bit for receiver (not used M=0)
;           10th data bit for transmitter (not used M10=0)
;0-->6:R9T8=9th data bit for transmitter (not used M=0)
;           10th data bit for receiver (not used M10=0)
;0-->5:TXDIR=UART_TX pin direction in single-wire mode
;            (no effect LOOPS=0)
;0-->4:TXINV=transmit data inversion (not inverted)
;0-->3:ORIE=overrun IE for OR (disabled)
;0-->2:NEIE=noise error IE for NF (disabled)
;0-->1:FEIE=framing error IE for FE (disabled)
;0-->0:PEIE=parity error IE for PF (disabled)
UART0_C3_NO_TXINV  EQU  0x00
;---------------------------------------------------------------
;UART0_C4
;    0-->  7:MAEN1=match address mode enable 1 (disabled)
;    0-->  6:MAEN2=match address mode enable 2 (disabled)
;    0-->  5:M10=10-bit mode select (not selected)
;01111-->4-0:OSR=over sampling ratio (16)
;               = 1 + OSR for 3 <= OSR <= 31
;               = 16 for 0 <= OSR <= 2 (invalid values)
UART0_C4_OSR_16           EQU  0x0F
UART0_C4_NO_MATCH_OSR_16  EQU  UART0_C4_OSR_16
;---------------------------------------------------------------
;UART0_C5
;  0-->  7:TDMAE=transmitter DMA enable (disabled)
;  0-->  6:Reserved; read-only; always 0
;  0-->  5:RDMAE=receiver full DMA enable (disabled)
;000-->4-2:Reserved; read-only; always 0
;  0-->  1:BOTHEDGE=both edge sampling (rising edge only)
;  0-->  0:RESYNCDIS=resynchronization disable (enabled)
UART0_C5_NO_DMA_SSR_SYNC  EQU  0x00
;---------------------------------------------------------------
;UART0_S1
;0-->7:TDRE=transmit data register empty flag; read-only
;0-->6:TC=transmission complete flag; read-only
;0-->5:RDRF=receive data register full flag; read-only
;1-->4:IDLE=idle line flag; write 1 to clear (clear)
;1-->3:OR=receiver overrun flag; write 1 to clear (clear)
;1-->2:NF=noise flag; write 1 to clear (clear)
;1-->1:FE=framing error flag; write 1 to clear (clear)
;1-->0:PF=parity error flag; write 1 to clear (clear)
UART0_S1_CLEAR_FLAGS  EQU  0x1F
;---------------------------------------------------------------
;UART0_S2
;1-->7:LBKDIF=LIN break detect interrupt flag (clear)
;             write 1 to clear
;1-->6:RXEDGIF=RxD pin active edge interrupt flag (clear)
;              write 1 to clear
;0-->5:(reserved); read-only; always 0
;0-->4:RXINV=receive data inversion (disabled)
;0-->3:RWUID=receive wake-up idle detect
;0-->2:BRK13=break character generation length (10)
;0-->1:LBKDE=LIN break detect enable (disabled)
;0-->0:RAF=receiver active flag; read-only
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS  EQU  0xC0
;---------------------------------------------------------------
;For LEDs
;Port D
PTD5_MUX_GPIO		EQU	(1 << PORT_PCR_MUX_SHIFT)
SET_PTD5_GPIO		EQU	(PORT_PCR_ISF_MASK :OR: \
						PTD5_MUX_GPIO)
;Port E
PTE29_MUX_GPIO		EQU	(1 << PORT_PCR_MUX_SHIFT)
SET_PTE29_GPIO		EQU	(PORT_PCR_ISF_MASK :OR: \
						PTE29_MUX_GPIO)
POS_RED				EQU	29
POS_GREEN			EQU	5
LED_RED_MASK		EQU	(1 << POS_RED)
LED_GREEN_MASK		EQU	(1 << POS_GREEN)
LED_PORTD_MASK		EQU	LED_GREEN_MASK
LED_PORTE_MASK		EQU	LED_RED_MASK
;****************************************************************
;MACROs
            MACRO
$Label      HEXA    $Char
;**********************************************************************
;Adjusts ASCII character in $Char for correct value on ['A','F'] if 
;character is more than '9'.
;Input:   $Char:  Character to adjust for hex digit
;Output:  $Char:  Adjusted hex digit
;Modify:  PSR,$Char
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            CMP     $Char,#'9'        ;if (Digit
            BLS     $Label.OK         ;         > '9') {
                                      ;  map to ['A','F']
            ADDS    $Char,$Char,#'A'
            SUBS    $Char,$Char,#('9' + 1)
$Label.OK                             ;}
            MEND         
;****************************************************************
;Program
;C source will contain main ()
;Only subroutines and ISRs in this assembly source
            AREA    MyCode,CODE,READONLY
			EXPORT	GetChar
			EXPORT	GetStringSB
			EXPORT	Init_UART0_IRQ
			EXPORT	PutChar
			EXPORT	PutNumHex
			EXPORT	PutNumUB
			EXPORT	PutStringSB
			EXPORT	PutCRLF
			EXPORT	UART0_IRQHandler
			EXPORT	Init_PIT_IRQ
			EXPORT	PIT_IRQHandler
			EXPORT	RxQRecord
			EXPORT	Count
			EXPORT	RunTimer
			EXPORT	Init_LED
			EXPORT	LED
			EXPORT	PutNumU
            ENTRY
;>>>>> begin subroutine code <<<<<
;---------------------------------------------------------------
Init_LED
;*********************************************************************
			PUSH 	{R0-R2}
			;Initialize ports
			LDR		R0, =SIM_SCGC5
			LDR		R1, =(SIM_SCGC5_PORTD_MASK :OR: \
							SIM_SCGC5_PORTE_MASK)
			LDR		R2, [R0, #0]
			ORRS	R2, R2, R1
			STR		R2, [R0, #0]
			;Select PORT E Pin 29 for GPIO to Red LED
			LDR		R0, =PORTE_BASE
			LDR		R1, =SET_PTE29_GPIO
			STR		R1, [R0, #PORTE_PCR29_OFFSET]
			;Select PORT D Pin 5 for GPIO to Green LED
			LDR		R0, =PORTD_BASE
			LDR		R1, =SET_PTD5_GPIO
			STR		R1, [R0, #PORTD_PCR5_OFFSET]
			;Init Port Data Direction Register
			LDR		R0, =FGPIOD_BASE
			LDR		R1, =LED_PORTD_MASK
			STR		R1, [R0, #GPIO_PDDR_OFFSET]
			LDR		R0, =FGPIOE_BASE
			LDR		R1, =LED_PORTE_MASK
			STR		R1, [R0, #GPIO_PDDR_OFFSET]
			POP 	{R0-R2}
			BX		LR
;---------------------------------------------------------------
LED
;**********************************************************************
;R0: 1 for Green, 0 for Red
;R1: 1 for on, 0 for off
;******************************************************************
			PUSH	{R0,R2}
			CMP		R0, #0
			BEQ		LEDRed
			LDR		R2, =FGPIOE_BASE
			LDR		R0, =LED_GREEN_MASK
			B		LEDToggle
LEDRed		LDR		R2, =FGPIOD_BASE
			LDR		R0, =LED_RED_MASK
LEDToggle	CMP		R1, #0
			BEQ		LEDOff
			STR		R0, [R2, #GPIO_PCOR_OFFSET]
			B		LEDEnd
LEDOff		STR		R0, [R2, #GPIO_PSOR_OFFSET]
LEDEnd		POP		{R0,R2}
			BX		LR
;---------------------------------------------------------------
Dequeue
;**********************************************************************
; Dequeues a character to R0 from queue referenced by R1.
; Sets/clears CCR bit C to reflect failure/success of dequeue.
; Input:   R1: Address of queue management record structure
; Output:  R0: Character dequeued
;          PSR.C = (Boolean) Failure
; Modify:  R0, PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save registers
            PUSH    {R2-R3}
;Dequeue
            LDRB    R2,[R1,#NUM_ENQD] ;check queue count
            CMP     R2,#0             ;if (queue not empty) {
            BEQ     DequeueFail
            LDR     R3,[R1,#OUT_PTR]  ;  get address of character
            LDRB    R0,[R3,#0]        ;  dequeue character
            ADDS    R3,R3,#1          ;  OutPointer++
            SUBS    R2,R2,#1          ;  NumberEnqueued--
            STRB    R2,[R1,#NUM_ENQD]
            LDR     R2,[R1,#BUF_PAST]  ;  if (OutPointer past buffer) {
            CMP     R3,R2
            BLO     DequeueOutPtr
            LDR     R3,[R1,#BUF_STRT] ;    adjust to start of buffer
DequeueOutPtr                         ;  }end if (OutPointer)
            STR     R3,[R1,#OUT_PTR]  ;  store updated OutPointer
            MOVS    R2,#0             ;  clear C flag (report successful)
            LSRS    R2,R2,#1
            B       DequeueDone       ;}end if (queue)
DequeueFail                           ;else { ;nothing to dequeue
            MOVS    R2,#1             ;  set C flag (report failure)
            LSRS    R2,R2,#1          ;}end else
DequeueDone                        
;Restore registers
            POP     {R2-R3}
            BX      LR
;---------------------------------------------------------------
DIVU
;**********************************************************************
;Divide unsigned
;Divides R1 by R0 and returns the quotient in R0 and the remainder in
;R1.  If divide by 0, R0 and R1 are unchanged, and C bit of APSR is set.
;Otherwise, C bit of APSR is clear.
;Input:  R0:  Divisor
;        R1:  Dividend
;Output:  R0:  Quotient
;         R1:  Remainder
;         C:   1 if divide by 0; 0 otherwise
;Modify:  R0,R1,APSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Other registers used
;R2:Bit mask
;R3:Counter
;R4:Quotient
            PUSH    {R2-R4}  ;Save temporary registers
            MOVS    R2,#1    ;Mask_MSB = 0x8000000
            LSLS    R2,R2,#31
            MOVS    R4,#0    ;Quotient != 0
            CMP     R0,#0    ;if (Divisor  != 0){
            BEQ     DIVU_Done;//C was set if R0 == 0
            CMP     R1,#0    ;  if (Dividend != 0) {
            BEQ     DIVU_0R0
            CMP     R0,#1    ;    if (Divisor != 1) {
            BEQ     DIVU_By1
            CMP     R0,R1    ;      if (Divisor <= Dividend) {
            BHI     DIVU_0
            MOVS    R2,#1    ;        Mask_MSB = 0x8000000
            LSLS    R2,R2,#31
            MOVS    R3,#0    ;        DivisorAlign = 0
DIVU_Align                   ;        repeat {
            ADDS    R3,R3,#1 ;          DivisorAlign++
            LSLS    R0,R0,#1 ;          Divisor <<= 1
                             ;        until ((significant bit shifted out)
            BCS     DIVU_Restore
            CMP     R0,R1    ;                || (R0 >= R1))
            BLO     DIVU_Align
                             ;        if (R0 = R1) {
            BEQ     DIVU_1R0
                             ;           Result is 1<<DivisorAlign Rem 0
                             ;        }
                             ;        else {
            SUBS    R3,R3,#1 ;          DivisorAlgin--
            LSRS    R0,R0,#1 ;          Restore divisor from last shift
                             ;        }
DIVU_Subtract                ;        repeat {
            CMP     R1,R0    ;          if (Dividend > Divisor) {
            BLO     DIVU_Subtract_None
            SUBS    R3,R3,#1 ;            DivisorAlign--    
            SUBS    R1,R1,R0 ;            Dividend -= Divisor
            LSLS    R4,R4,#1 ;            Quotient = (Quotient << 1) + 1
            ADDS    R4,R4,#1 ;
            LSRS    R0,R0,#1 ;            Divisor >>= 1
            B       DIVU_Subtract_EndIf
DIVU_Subtract_None           ;          } else {
            SUBS    R3,R3,#1 ;            DivisorAlign--
            LSLS    R4,R4,#1 ;            Quotient = (Quotient << 1)
            LSRS    R0,R0,#1 ;            Divisor >>= 1
DIVU_Subtract_EndIf          ;          }
            CMP     R3,#0    ;        } until (DivisorAlign < 0) {
            BLT     DIVU_Quotient
            B       DIVU_Subtract
                             ;      } if (Divisor <= Dividend)
                             ;    } if (Dividend != 1)
                             ;  } if (Dividend != 0)
                             ;} if (Divisor != 0)
DIVU_Adjust LSLS    R4,R4,R3 ;Quotient <<= DivisorAlign           
DIVU_Quotient
            MOVS    R0,#0    ;Clear carry to report success
            LSLS    R0,R0,#1
            ORRS    R0,R4    ;Move quotient to R0, setting Z and V
DIVU_Done   POP     {R2-R4}
            BX      LR
DIVU_0R0    MOVS    R1,#0
            B       DIVU_Quotient
DIVU_By1    MOVS    R4,R1
            MOVS    R1,#0
DIVU_0      B       DIVU_Quotient
DIVU_Restore                 ;Dividend MSb was shifted out
            SUBS    R3,R3,#1 ;DivisorAlgin--
            LSRS    R0,R0,#1 ;Restore divisor from last shift
            ORRS    R0,R0,R2 ;
            B       DIVU_Subtract
DIVU_1R0    MOVS    R4,#1
            MOVS    R1,#0
            B       DIVU_Adjust
;---------------------------------------------------------------
Enqueue
;**********************************************************************
; Enqueue character from R0.
; Sets/clears CCR bit C to reflect failure/success of dequeue.
; Input:   R0: Character to enqueue
;          R1: Address of queue management record structure
; Output:  CCR.C = (Boolean) Failure
; Modify:  CCR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save registers
            PUSH    {R2-R3}
;Enqueue
            LDRB    R2,[R1,#NUM_ENQD] ;check queue count
            LDRB    R3,[R1,#BUF_SIZE] ;against queue capacity
            CMP     R2,R3             ;if queue not full
            BHS     EnqueueFail
            LDR     R3,[R1,#IN_PTR]   ;  address for character
            STRB    R0,[R3,#0]        ;  enqueue character
            ADDS    R3,R3,#1          ;  InPointer++
            ADDS    R2,R2,#1          ;  NumberEnqueued++
            STRB    R2,[R1,#NUM_ENQD]
            LDR     R2,[R1,#BUF_PAST] ;  if (InPointer past buffer) {
            CMP     R3,R2
            BLO     EnqueueInPtr
            LDR     R3,[R1,#BUF_STRT] ;    adjust to start of buffer
EnqueueInPtr                          ;  }end if (InPointer)
            STR     R3,[R1,#IN_PTR]   ;  store updated InPointer
            MOVS    R2,#0             ;  clear C flag (report successful)
            LSRS    R2,R2,#1
            B       EnqueueDone       ;}end if (queue)
EnqueueFail                           ;else {;no room in queue
            MOVS    R2,#1             ;  set C flag (report failure)
            LSRS    R2,R2,#1          ;}end else
EnqueueDone                        
;Restore registers
            POP     {R2-R3}
            BX      LR
;---------------------------------------------------------------
GetChar
;**********************************************************************
;Get character:
;Receives the next character from the receive queue.
;Output:  R0: Character received
;Modifies:  R0, PSR
;---------------------------------------------------------------
; Wait until receiver is ready
            PUSH  {R1, LR}                  ;Save temporary registers
            LDR   R1,=RxQRecord         ;R1 = Receive Queue address
GetCharLoop	CPSID	I
			BL	  Dequeue				;Receive character from the queue
			CPSIE	I
			BCS		GetCharLoop
            POP   {R1, PC}					;Restore R1
            BX    LR					;Return
;---------------------------------------------------------------
GetStringSB
;**********************************************************************
;Get string in secure buffer:
;Receives each character in string from GetChar and adds NULL 
;termination, preventing buffer overrun for buffer size specified.  
;Input of CR (from pressing "Enter" key) terminates input.  
;Handles backspace (BS) control code, but all other control 
;codes and escape sequences are ignored.
;NOTE:  PuTTY Terminal->Keyboard options may need to be changed for BS
;       to work; needs to be Control-H instead of Control-?.
;Calls:  GetChar
;        PutChar
;Input:  R0: Address of string buffer
;        R1: Capacity of string buffer
;Modifies:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            PUSH  {R0-R3,LR}    ;save registers modified
;Register map
;R0:  current string character
;R1:  size of memory buffer (input parameter)
;R2:  current string index or character count
;R3:  address of string (from input parameter R0)
            CMP   R1,#0            ;if (buffer capacity) {
            BEQ   GetStringSBNull
            MOV   R3,R0            ;  base address of string
            MOVS  R2,#0            ;  character count
            SUBS  R1,R1,#1         ;  maximum characters
            BEQ   GetStringSBFull  ;  while (available buffer space) {
GetStringSBChar
            BL    GetChar          ;    receive character
GetStringSBCharInspect
            CMP   R0,#ESC          ;    if escape
            BEQ   GetStringSBESC   ;      may be escape sequence
            CMP   R0,#BS           ;    elseif backspace
            BEQ   GetStringSBBS    ;      evaluate position
            CMP   R0,#CR           ;    elseif CR
                                   ;      done 
            BEQ   GetStringSBTerminate
            CMP   R0,#' '          ;    elseif other control character
            BLO   GetStringSBChar  ;      ignore
            CMP   R0,#DEL
            BEQ   GetStringSBChar  ;    else {
            BL    PutChar          ;      echo character
            STRB  R0,[R3,R2]       ;      store in string
            ADDS  R2,R2,#1         ;      character count ++
            CMP   R2,R1            ;    }end else
            BLO   GetStringSBChar  ;  }end while (available buffer space)
GetStringSBFull                    ;  repeat { ;with no available space
            BL    GetChar          ;    receive character
            CMP   R0,#BS           ;    if backspace
            BEQ   GetStringSBBS    ;      evaluate position            
            CMP   R0,#CR
            BNE   GetStringSBFull  ;  } until CR received
GetStringSBTerminate               ;}end if (buffer capacity)
            MOVS  R1,#NULL         ;terminate with NULL
            STRB  R1,[R3,R2]
GetStringSBDone
            BL    PutChar          ;echo CR
            MOVS  R0,#LF           ;print LF
            BL    PutChar
            POP   {R0-R3,PC}       ;restore registers and return
GetStringSBBS
            CMP   R2,#0            ;if (not at start of string) {
            BEQ   GetStringSBChar
            BL    PutChar          ;  echo backspace
            SUBS  R2,R2,#1         ;  character count  --
            MOVS  R0,#' '          ;  overwrite with space
            BL    PutChar
            MOVS  R0,#BS           ;  back space
            BL    PutChar
            B     GetStringSBChar
                                   ;}end if and resume while
GetStringSBESC
            MOVS  R4,#1            ;may be first of escape sequence
            BL    GetChar          ;if (next character == '[') {
            CMP   R0,#'['
            BNE   GetStringSBCharInspect
            CMP   R0,#'~'          ;  if (not end of sequnece) {
            BEQ   GetStringSBChar
GetStringSBESCNext                 ;    repeat {
            BL    GetChar          ;      consume next in sequence
            CMP   R0,#'~'
            BNE   GetStringSBESCNext
            B     GetStringSBChar  ;    } until (last consumed)
                                   ;  } if (not end of sequence)
                                   ;} if (next character == "[")
GetStringSBNull                    ;repeat {
            BL    GetChar          ;  receive character
            CMP   R0,#CR
            BNE   GetStringSBNull
                                   ;} until CR received
            B     GetStringSBDone
;---------------------------------------------------------------
InitQueue
;**********************************************************************
; Initializes FIFO queue management record structure where R1 points
; for byte queue buffer where R0 points and whose size is in R2.
; Input:  R0:  Address of queue buffer
;         R1:  Address of queue record
;         R2:  Capacity of queue buffer in bytes
; Output:  None
; Modifies:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            PUSH    {R0}
            STR     R0,[R1,#IN_PTR]
            STR     R0,[R1,#OUT_PTR]
            STR     R0,[R1,#BUF_STRT]
            ADDS    R0,R0,R2
            STR     R0,[R1,#BUF_PAST]
            STRB    R2,[R1,#BUF_SIZE]
            MOVS    R0,#0
            STRB    R0,[R1,#NUM_ENQD]
            POP     {R0}
            BX      LR
;---------------------------------------------------------------
Init_UART0_IRQ
;**********************************************************************
;Initialize UART0 for interrupts:
;Initializes UART0 for interrupts with 9600 baud and 8N1 format
;Assumes 48-MHz core clock.
;Uses OpenSDA USB serial port connection through PTA1 and PTA2
;Input:  None
;Output:  None
;Modifies:  PSR
;---------------------------------------------------------------
			PUSH	{R0-R3, LR}						;Save registers 
			
			LDR		R0, =TxQBuffer
			LDR		R1, =TxQRecord
			MOVS	R2, #0x50
			BL		InitQueue
			
			LDR		R0, =RxQBuffer
			LDR		R1, =RxQRecord
			MOVS	R2, #0x50
			BL		InitQueue
			
			;Select MCGPLLCLK / 2 as UART0 clock source
            LDR     R0,=SIM_SOPT2
            LDR     R1,=SIM_SOPT2_UART0SRC_MASK
            LDR     R2,[R0,#0]
            BICS    R2,R2,R1
            LDR     R1,=SIM_SOPT2_UART0_MCGPLLCLK_DIV2
            ORRS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Set UART0 for external connection
            LDR     R0,=SIM_SOPT5
            LDR     R1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
            LDR     R2,[R0,#0]
            BICS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Enable UART0 module clock
            LDR     R0,=SIM_SCGC4
            LDR     R1,=SIM_SCGC4_UART0_MASK
            LDR     R2,[R0,#0]
            ORRS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Enable PORT A module clock
            LDR     R0,=SIM_SCGC5
            LDR     R1,=SIM_SCGC5_PORTA_MASK
            LDR     R2,[R0,#0]
            ORRS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Select PORT A Pin 1 (J1 Pin 02) for UART0 RX
            LDR     R0,=PORTA_PCR1
            LDR     R1,=PORT_PCR_SET_PTA1_UART0_RX
            STR     R1,[R0,#0]
            ;Select PORT A Pin 2 (J1 Pin 04) for UART0 TX
            LDR     R0,=PORTA_PCR2
            LDR     R1,=PORT_PCR_SET_PTA2_UART0_TX
            STR     R1,[R0,#0]
			
			;Disable UART0
            LDR     R0,=UART0_BASE
            MOVS    R1,#UART0_C2_T_R
            LDRB    R2,[R0,#UART0_C2_OFFSET]
            BICS    R2,R2,R1
            STRB    R2,[R0,#UART0_C2_OFFSET]
			
			;Set UART0 IRQ priority
			LDR		R0, =UART0_IPR
			;LDR	R1, =NVIC_IPR_UART0_MASK
			LDR		R2, =NVIC_IPR_UART0_PRI_3
			LDR		R3, [R0, #0]
			;BICS	R3, R3, R1
			ORRS	R3, R3, R2
			STR		R3, [R0, #0]
			;Clear any pending UART0 interrupts
			LDR		R0, =NVIC_ICPR
			LDR		R1, =NVIC_ICPR_UART0_MASK
			STR		R1, [R0, #0]
			;Unmask UART0_interruprs
			LDR		R0, =NVIC_ISER
			LDR		R1, =NVIC_ISER_UART0_MASK
			STR		R1, [R0, #0]
			
			LDR		R0, =UART0_BASE
            ;Set for 9600 baud from 96MHz PLL clock
            MOVS    R1,#UART0_BDH_9600
            STRB    R1,[R0,#UART0_BDH_OFFSET]
            MOVS    R1,#UART0_BDL_9600
            STRB    R1,[R0,#UART0_BDL_OFFSET]
            MOVS    R1,#UART0_C1_8N1
            STRB    R1,[R0,#UART0_C1_OFFSET]
            MOVS    R1,#UART0_C3_NO_TXINV
            STRB    R1,[R0,#UART0_C3_OFFSET]
            MOVS    R1,#UART0_C4_NO_MATCH_OSR_16
            STRB    R1,[R0,#UART0_C4_OFFSET]
            MOVS    R1,#UART0_C5_NO_DMA_SSR_SYNC
            STRB    R1,[R0,#UART0_C5_OFFSET]
            MOVS    R1,#UART0_S1_CLEAR_FLAGS
            STRB    R1,[R0,#UART0_S1_OFFSET]
            MOVS    R1,#UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
            STRB    R1,[R0,#UART0_S2_OFFSET]
            MOVS    R1,#UART0_C2_T_RI
            STRB    R1,[R0,#UART0_C2_OFFSET]
			
			POP		{R0-R3, PC}					;Return registers
			BX		LR							;Return
;---------------------------------------------------------------
UART0_ISR
UART0_IRQHandler
;**********************************************************************
;Interrupt service routine
;Checks the type of interrupt, then acts on it
;Transmit interrupt transmits next item in queue
;Receive interrupt receives next item to queue
;---------------------------------------------------------------
			PUSH	{R0-R3, LR}					;Save registers 
			LDR		R2, =UART0_BASE				;Get UART0 Base address
			LDRB	R1, [R2, #UART0_S1_OFFSET]	;Load S1
			MOVS	R0, #UART0_S1_RDRF_MASK		;Determine if RDRF
			MOVS	R3, R1
			ANDS	R1, R1, R0
			BNE		ISR_Rx						;If so, Receive
			MOVS	R0, #UART0_S1_TDRE_MASK		;Otherwise check TDRE
			ANDS	R3, R3, R0
			BNE		ISR_Tx						;If so, Transmit
			B		ISR_End						;Otherwise finish
ISR_Rx		LDRB	R0, [R2, #UART0_D_OFFSET]	;Load D
			LDR		R1, =RxQRecord				;Put D in Receive Buffer
			BL		Enqueue
			B		ISR_End						;Finish
ISR_Tx		LDR		R1, =TxQRecord				;Read next in Transmit Buffer
			BL		Dequeue
			BCC		ISR_TxS						;If successful, transmit
			MOVS	R1, #UART0_C2_T_RI			;Disable Transmit interrupts
			STRB	R1, [R2, #UART0_C2_OFFSET]
			B		ISR_End						;Finish
ISR_TxS		STRB	R0, [R2, #UART_D_OFFSET]	;Write to UART0_D_OFFSET
ISR_End		POP		{R0-R3, PC}					;Restore registers
			BX		LR							;Return
;---------------------------------------------------------------
Init_PIT_IRQ
;*********************************************************************
			PUSH	{R0-R3}
			;Enable clock for PIT module
			LDR		R0, =SIM_SCGC6
			LDR		R1, =SIM_SCGC6_PIT_MASK
			LDR		R2, [R0, #0]	;current SIM_SCGC6 value
			ORRS	R2, R2, R1		;only PIT bit set
			STR		R2, [R0, #0]	;update SIM_SCGC6
		
			;Disable PIT timer 0
			LDR		R0, =PIT_CH0_BASE
			LDR		R1, =PIT_TCTRL_TEN_MASK
			LDR		R2, [R0, #PIT_TCTRL_OFFSET]
			BICS	R2, R2, R1
			
			STR		R2, [R0, #PIT_TCTRL_OFFSET]
			;Set PIT interrupt priority
			LDR		R0, =PIT_IPR
			LDR		R1, =NVIC_IPR_PIT_MASK
			;LDR	R2, NVIC_IPR_PIT_PRI_0
			LDR		R3, [R0, #0]
			BICS	R3, R3, R1
			;ORRS	R3, R3, R2
			STR		R3, [R0, #0]
			;Clear any pending PIT interrupts
			LDR		R0, =NVIC_ICPR
			LDR		R1, =NVIC_ICPR_PIT_MASK
			STR		R1, [R0, #0]
			;Unmask PIT interrupts
			LDR		R0, =NVIC_ISER
			LDR		R1, =NVIC_ISER_PIT_MASK
			STR		R1, [R0, #0]
			;Enable PIT module
			LDR	R0, =PIT_BASE
			LDR	R1, =PIT_MCR_EN_FRZ
			STR	R1, [R0, #PIT_MCR_OFFSET]
			;Set PIT timer 0 period for 0.01 s
			LDR	R0, =PIT_CH0_BASE
			LDR	R1, =PIT_LDVAL_10ms
			STR	R1, [R0, #PIT_LDVAL_OFFSET]
			;Enable PIT timer 0 interrupt
			LDR	R1, =PIT_TCTRL_CH_IE
			STR	R1, [R0, #PIT_TCTRL_OFFSET]
			
			POP		{R0-R3}
			BX		LR
;--------------------------------------------------------------
PIT_ISR
PIT_IRQHandler
;**********************************************************************
			PUSH	{R0-R1}				;Save registers
			LDR		R0, =RunTimer	;Load RunStopWatch
			LDRB	R0, [R0, #0]
			CMP		R0, #0				;Check if it's 0
			BEQ		PIT_ISR_End			;If so, finish
			LDR		R0, =Count			;Load Count
			LDR		R1, [R0, #0]
			ADDS	R1, R1, #1			;Increment Count
			STR		R1, [R0, #0]		;Store it back
			LDR		R0, =PIT_TFLG0
			MOVS	R1, #PIT_TFLG_TIF_MASK
			STR		R1, [R0, #0]
PIT_ISR_End	POP		{R0-R1}				;Return registers
			BX		LR					;Finish			
;--------------------------------------------------------------
LengthStringSB
;**********************************************************************
;Length of string in secure buffer
;Determines length of NULL-terminated string where R0 points.
;Prevents buffer overrun for buffer size specified.
;Input:  R0: Address of string buffer
;        R1: Capacity of string buffer  
;Output:  R2:  Length of string 
;Modifies:  R1,PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            PUSH  {R3}
            MOVS  R2,#0         ;Length = 0
            CMP   R1,#0         ;if (buffer capacity) {
            BEQ   LengthStringSBDone
LengthStringSBDo                ;  do {
            LDRB  R3,[R0,R2]    ;    if (String[Length] != NULL) {
            CMP   R3,#NULL
            BEQ   LengthStringSBDone
            ADDS  R2,R2,#1      ;      Length++
            CMP   R2,R1
            BLO   LengthStringSBDo
                                ;  } while ((String[Length-1] != NULL)
                                ;           && Length < Capacity) {
LengthStringSBDone
            POP   {R3}
            BX    LR
;---------------------------------------------------------------
PutChar
;**********************************************************************
;Put character:
;Adds a character to the transmit queue.
;Input:  R0: Character to send
;Modifies:  PSR
;---------------------------------------------------------------
; Wait until transmitter is ready
            PUSH	{R1-R2, LR}                 ;Save temporary registers
            LDR		R1, =TxQRecord         	;R1 = Transmit Queue address
PutCharLoop	CPSID	I
			BL		Enqueue					;Write character to send queue
			CPSIE	I
			BCS		PutCharLoop
			LDR		R1, =UART0_BASE			;Enable TIE
			MOVS	R2, #UART0_C2_TI_RI
			STRB	R2, [R1, #UART0_C2_OFFSET]
            POP		{R1-R2, PC}				;Restore R1
            BX		LR						;Return
;---------------------------------------------------------------
PutCRLF
;**********************************************************************
;Put carriage return and line feed:
;Transmits new line sequence using PutChar.
;Calls:  PutChar
;Modifies:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            PUSH   {R0,LR}  ;Save registers
            MOVS   R0,#CR   ;Send CR
            BL     PutChar  ;Call PutChar
            MOVS   R0,#LF   ;Send LF
            BL     PutChar  ;Call PutChar
            POP    {R0,PC}  ;Restore registers
;---------------------------------------------------------------
PutNumHex
;**********************************************************************
;Prints hex representation of unsigned word number in R0.
;Input:   R0:  Unsigned word value
;Modify:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save temp. registers
            PUSH    {R1-R2,LR}
;Print hex digit for each nibble, starting with most significant
                                 ;hex digit count
            MOVS    R1,#(WORD_SIZE * BYTE_BITS / NIBBLE_BITS)
                                 ;shift amount for most sig. nibble
            MOVS    R2,#((WORD_SIZE * BYTE_BITS) - NIBBLE_BITS)
                                 ;mask for least significant nibble 
PutNumHexLoop                    ;repeat {
            RORS    R0,R0,R2     ;  move most significant nibble to least
            BL      PutNumHexN   ;  print least significant nibble
            SUBS    R1,R1,#1     ;} until ((hex digit count--) == 0)
            BNE     PutNumHexLoop
; Restore temp. registers
            POP     {R1-R2,PC}
;---------------------------------------------------------------
PutNumHexB
;**********************************************************************
;Prints hex representation of unsigned least byte in R0.
;Input:   R0:  Unsigned byte value
;Modify:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save temp. registers
            PUSH    {R1,LR}
;Print hex digit for each nibble, starting with most significant
            MOV     R1,R0        ;preserve original byte
                                 ;print nibble 1
            LSRS    R0,R0,#NIBBLE_BITS
            BL      PutNumHexN   ;print nibble 1
            MOV     R0,R1        ;restore original byte
            BL      PutNumHexN   ;print nibble 0
            POP     {R1,PC}
;---------------------------------------------------------------
PutNumHexN
;**********************************************************************
;Prints hex representation of unsigned least nibble in R0.
;Input:   R0:  Unsigned nibble value
;Modify:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save temp. registers
            PUSH    {R0-R1,LR}
;Print hex digit of least significant nibble
            MOVS    R1,#NIBBLE_MASK
            ANDS    R0,R0,R1     ;value of nibble 1
            ADDS    R0,R0,#'0'   ;ASCII of digit in [0,9]
PutNumHexNAdj \
            HEXA    R0           ;ASCII of digit in [A,F]
            BL      PutChar      ;print digit
; Restore temp. registers
            MOV     R0,R1
            POP     {R0-R1,PC}
;---------------------------------------------------------------
PutNumU
;**********************************************************************
;Put number unsigned
;Prints unsigned number in R0 using a minimum number of characters
;using PutChar
;Calls:  DIVU
;        PutChar
;Input:  R0:  Unsigned value
;Modify:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
            PUSH   {R0-R1,LR}
;Create null-terminated string on stack
;MSB will be at TOS when done
            MOVS   R1,#NULL  ;Push NULL
            PUSH   {R1}
PutNumURepeat                ;repeat {
            ;DIVU:  R0 rem R1 = R1 / R0
            MOV    R1,R0     ;  Put dividend in R1
            MOVS   R0,#10    ;  Divisor is 10
            BL     DIVU      ;  Divide number by 10
            ADDS   R1,#'0'   ;  Convert digit value to digit character
            PUSH   {R1}      ;  Push next least digit character
            CMP    R0,#0     ;} until (remaining value == 0)
            BNE    PutNumURepeat
PutNumUWhile
            POP    {R0}      ;while (TOS character != NULL) {
            CMP    R0,#NULL
            BEQ    PutNumUDone
            BL     PutChar   ;  print digit
            B      PutNumUWhile
                             ;}
PutNumUDone POP    {R0-R1,PC}
;---------------------------------------------------------------
PutNumUB
;**********************************************************************
;Prints unsigned byte number in R0 using a minimum number of characters
;Calls:  PutNumU
;Input:  R0:  Unsigned byte value
;Modify:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save registers modified
            PUSH   {R0-R1,LR}
;Mask off byte value from R0
            MOVS   R1,#BYTE_MASK
            ANDS   R0,R0,R1
;Print number
            BL     PutNumU
;Restore registers modified
PutNumUBDone
            POP    {R0-R1,PC}
            ALIGN
;---------------------------------------------------------------
PutStringSB
;**********************************************************************
;Put string from secure buffer:
;Sends each character in null-terminated string to PutChar.
;Calls:  PutChar
;Input:  R0: Address of string buffer
;        R1: Capacity of string buffer
;Modifies:  PSR
;---------------------------------------------------------------
;Provided to Ari Sanders
;R. W. Melton
;October 23, 2015
;**********************************************************************
;Save registers
            PUSH   {R0-R2,LR}
;Register Map
;R0:  Current string character
;R1:  Capacity of string buffer (input parameter);
;     Address of first byte past string buffer
;R2:  Address of string buffer (from input parameter R0)
            CMP    R1,#0          ;if (buffer capacity) {
            BEQ    PutStringSBDone
            ADDS   R1,R1,R0       ;First address past buffer
            MOV    R2,R0          ;R0 needed for PutChar parameter
PutStringSBLoop                   ;repeat {
            LDRB   R0,[R2,#0]     ;  CurrentChar of string
            CMP    R0,#NULL       ;  if (CurrentChar != NULL) {
            BEQ    PutStringSBDone
            BL     PutChar        ;    Send current char to terminal
            ADDS   R2,R2,#1       ;    CurrentCharPtr++
            CMP    R2,R1
            BEQ    PutStringSBDone
            B      PutStringSBLoop
                                  ;} until ((CurrentChar == NULL)
                                  ;         || (Past end of buffer))
;Restore registers
PutStringSBDone
            POP    {R0-R2,PC}
;---------------------------------------------------------------
;>>>>>   end subroutine code <<<<<
            ALIGN
;**********************************************************************
;Constants
            AREA    MyConst,DATA,READONLY
;>>>>> begin constants here <<<<<
;>>>>>   end constants here <<<<<
;**********************************************************************
;Variables
            AREA    MyData,DATA,READWRITE
;>>>>> begin variables here <<<<<
RunTimer	SPACE	1
			ALIGN
Count		SPACE	4
QBuffer     SPACE   Q_BUF_SZ  ; FIFO queue buffer
            KEEP    QBuffer
		    ALIGN
QRecord     SPACE   Q_REC_SZ  ; FIFO queue management record
            KEEP    QRecord
TxQBuffer   SPACE   XQ_BUF_SZ  ; Transmit queue buffer
            KEEP    TxQBuffer
		    ALIGN
TxQRecord   SPACE   Q_REC_SZ  ; Transmit queue management record
            KEEP    TxQRecord
RxQBuffer   SPACE   XQ_BUF_SZ  ; Receive queue buffer
            KEEP    RxQBuffer
		    ALIGN
RxQRecord   SPACE   Q_REC_SZ  ; Receive queue management record
            KEEP    RxQRecord
;>>>>>   end variables here <<<<<
            END