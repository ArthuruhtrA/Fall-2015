/*
1. Write an assembly language subroutine AddIntMultiU that adds the n-word unsigned
number in memory starting at the address in R2 to the n-word unsigned number in
memory starting at the address in R1, and it stores the result to memory starting at the
address in R0; where the value in R3 is n. If the result is a valid n-word unsigned
number, it then stores zero (0) in R0 as the return code for success; otherwise it stores
one (1) in R0 as the return code for overflow.
*/
AddIntMultiU
;R2 + R1 => STR R0
;R3 = n = how many words
;0 => R0 if result is n-word
;1 => R0 if overflow
;offset register
;2 registers for values
;************************************************************
			PUSH	{R4-R6}			;Save registers
			MOVS	R4, #0			;Initial offset
			LDR		R5, [R2, #0]	;Load first word of R2 into R5
			LDR		R6, [R1, #0]	;Load first word of R1 into R6
			ADDS	R5, R5, R6		;Add them inot R5
			STR		R5, [R0, #0]	;Store to first word of R0
AIMU_Loop	SUBS	R3, R3, #1		;Decrement n
			CMP		R3, #0			;Check if it's 0
			BEQ		AIMU_End		;If so, clean up and finish
			ADD		R4, R4, #1		;Increment offset
			LDR		R5, [R2, R4]	;Load next word of R2 into R5
			LDR		R6, [R1, R4]	;Load next word of R2 into R5
			ADCS	R5, R5, R6		;Add them into R5
			STR		R5, [R0, R4]	;Store to next word of R0
			B		AIMU_Loop		;Loop
AIMU_End	POP		{R4-R6}			;Restore registers
			;R0 = 1 if overflow, else 0
			BVS		AIMU_Over		;Set return value
			MOVS	R0, #0			;0 if no overflow
			B		AIMU_Finish
AIMU_Over	MOVS	R0, #1			;1 if overflow
AIMU_Finish	BX		LR				;Return