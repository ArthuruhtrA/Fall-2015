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
			PUSH	{R0-R3}						;Save registers 
			
			LDR		R0, =TxQBuffer
			LDR		R1, =TxQRecord
			LDR		R2, =Q_BUF_SZ
			BL		InitQueue
			
			LDR		R0, =RxQBuffer
			LDR		R1, =RxQRecord
			LDR		R2, =Q_BUF_SZ
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
			
			POP		{R0-R3}						;Return registers
			BX		LR							;Return
;---------------------------------------------------------------

            DCD    UART0_ISR	      ;28:UART0 (status; error)

;---------------------------------------------------------------
UART0_ISR
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
			LDR		R1, =RxQBuffer				;Put D in Receive Buffer
			BL		Enqueue
			B		ISR_End						;Finish
ISR_Tx		LDR		R1, =TxQBuffer				;Read next in Transmit Buffer
			BL		Dequeue
			BCC		ISR_TxS						;If successful, transmit
			MOVS	R1, #UART0_C2_T_RI			;Disable Transmit interrupts
			STRB	R1, [R2, #UART0_C2_OFFSET]
			B		ISR_End						;Finish
ISR_TxS		STRB	R0, [R2, #UART_D_OFFSET]	;Write to UART0_D_OFFSET
ISR_End		POP		{R0-R3, PC}					;Restore registers
			BX		LR							;Return
;---------------------------------------------------------------
GetChar
;**********************************************************************
;Get character:
;Receives the next character from the receive queue.
;Output:  R0: Character received
;Modifies:  R0, PSR
;---------------------------------------------------------------
; Wait until receiver is ready
            PUSH  {R1}                  ;Save temporary registers
            LDR   R1,=RxQBuffer         ;R1 = Receive Queue address
			BL	  Dequeue				;Receive character from the queue
            POP   {R1}					;Restore R1
            BX    LR					;Return
;---------------------------------------------------------------
PutChar
;**********************************************************************
;Put character:
;Adds a character to the transmit queue.
;Input:  R0: Character to send
;Modifies:  PSR
;---------------------------------------------------------------
; Wait until transmitter is ready
            PUSH	{R1-R2}                 ;Save temporary registers
            LDR		R1, =TxQBuffer         	;R1 = Transmit Queue address
			BL		Enqueue					;Write character to send queue
			LDR		R1, =UART0_BASE			;Enable TIE
			MOVS	R2, #UART0_C2_TI_RI
			STRB	R2, [R1, #UART0_C2_OFFSET]
            POP		{R1-R2}					;Restore R1
            BX		LR						;Return
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