; 1. Write the subroutine Init_PIT_IRQ code to initialize the PIT to
; generate an interrupt every 0.01s from channel 0.
Init_PIT_IRQ
			PUSH	{R0-R3}
			;Enable clock for PIT module
			LDR		R0, =SIM_SCGC_6
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
		
			;NVIC_ICPR
			;31-00:CLRPEND=pending status for HW IRQ sources;
			;			read:	0 = not pending;	1 = pending
			;			write:	0 = no effect;
			;					1 = change status to not pending
			;22:PIT IRQ pending status
			NVIC_ICPR_PIT_MASK	EQU	PIT_IRQ_MASK
			;----------------------------------------------------
			;NVIC_IPR0-NVIC_IPR7
			;2-bit priority:	00 = highest;	11 = lowest
			;--PIT
			PIT_IRQ_PRIORITY	EQU	0
			NVIC_IPR_PIT_MASK	EQU	(3 << PIT_PRI_POS)
			NVIC_IPR_PIT_PRI_0	EQU	\
								(PIT_IRQ_PRIORITY << PIT_PRI_POS)
			;----------------------------------------------------
			;NVIC_ISER
			;31-00:SETENA=masks for HW IRQ sources;
			;			read:	0 = masked;		1 = unmasked
			;			write:	0 = no effect;	1 = unmask
			;22:PIT IRQ mask
			NVIC_ISER_PIT_MASK	EQU	PIT_IRQ_MASK
			;-----------------------------------------------------
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
		
			;PIT_LDVALn:	PIT load value register n
			;31-00:TSV=timer start value (period in clock cycles - 1)
			;Clock ticks for 0.01s at 24 MHz count rate
			;0.01s * 24,000,000 Hz = 240,000
			;TSV = 240,000 - 1
			PIT_LDVAL_10ms	EQU	239999
			;-----------------------------------------------------
			;PIT_MCR:	PIT module control register
			;1-->0:FRZ=freeze (continue'/stop in debug mode)
			;0-->1:MDIS=module disable (PIT section)
			;			RTI timer not affected
			;			must be enabled before any other PIT setup
			PIT_MCR_EN_FRZ	EQU	PIT_MCR_FRZ_MASK
			;-----------------------------------------------------
			;PIT_TCTRLn:	PIT timer control register n
			;0-->2:CHN=chain mode (enable)
			;1-->1:TIE=timer interrupt enable
			;1-->0:TEN=timer enable
			PIT_TCTRL_CH_IE	EQU	\
				(PIT_TCTRL_TEN_MASK :OR: \PIT_TCTRL_TIE_MASK)
			;-----------------------------------------------------
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

-------------------
; 2. Write the code to “install” the PIT_ISR interrupt handler in the
; KL46 vector table.
			DCD	PIT_ISR	;38
		
-------------------
; 3. Write the ISR PIT_ISR for the PIT module. On a PIT interrupt, if the
; (byte) variable RunStopWatch is not zero, PIT_ISR increments the (word)
; variable Count; otherwise it leaves Count unchanged. In either case,
; make sure the ISR clears the interrupt condition before exiting. 
PIT_ISR
			PUSH	{R0-R1}				;Save registers
			LDR		R0, =RunStopWatch	;Load RunStopWatch
			LDRB	R0, [R0, #0]
			CMP		R0, #0				;Check if it's 0
			BEQ		PIT_ISR_End			;If so, finish
			LDR		R0, =Count			;Load Count
			LDR		R1, [R0, #0]
			ADDS	R1, R1, #1			;Increment Count
			STR		R0, [R1, #0]		;Store it back
PIT_ISR_End	POP		{R0-R1}				;Return registers
			BX		LR					;Finish