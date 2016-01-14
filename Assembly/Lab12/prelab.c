/* 1. Write C code to initialize the KL46 DAC0 for continuous (non-buffer) 12-bit
 * conversion of DAC0_DAT0 to an analog value of range (0, 3.3] V. Follow the class
 * notes on the DAC posted on myCourses. You should use the #define names in the
 * provided Exercise12_C_Stub.c file.
 */

#define PTE30_MUX_DAC0_OUT (0 << PORT_PCR_MUX_SHIFT)
#define SET_PTE30_DAC0_OUT (PORT_PCR_ISF_MASK | PTE30_MUX_DAC0_OUT)
/* DAC0_C1: DMA and buffer mode disabled
 * DMAEN = 0 (bit 7)
 * DACBFEN = 0 (bit 0)
 */
#define DAC_C1_BUFFER_DISABLED (0x00u)#define DAC_C0_ENABLE (DAC_C0_DACEN_MASK | DAC_C0_DACRFS_MASK)
/* DAC0_C0: DAC enabled and input voltage
 * DACEN = 1 (bit 7)
 * DACRFS = 1 (bit 6)
 */
#define DAC_C0_ENABLE (DAC_C0_DACEN_MASK | DAC_C0_DACRFS_MASK)
/* DAC_DAT0: Digital value for analog conversion
 * DAC0_DAT0[11:8] = 0
 * DAC0_DAT0[7:0] = 0
 */
#define DAC_DATL_MIN (0x00u)
#define DAC_DATH_MIN (0x00u)

//Enable Clocks for DAC0 and PORT E
SIM->SCGC6 |= SIM_SCGC6_DAC0_MASK;
SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;

//Select pin for DAC0
/* PORT E Pin 30 (J4 Pin 11): DAC_OUT */
PORTE->PCR[30] = SET_PTE30_DAC0_OUT;

//Configure DAC0
DAC0->C1 = DAC_C1_BUFFER_DISABLED;
DAC0->C0 = DAC_C0_ENABLE;
DAC->DAT[0].DATL = DAC_DATH_MIN;
DAC->DAT[0].DATH = DAC_DATH_MIN;

UInt16 *DAC0_table = &DAC0_table_0;

/* 2. Write C code to initialize and calibrate the KL46 ADC0 for polled conversion of
 * single-ended channel 23 )AD23), which is connected to DAC0 output, to an unsigned
 * 10-bit value right-justified in ADC0_RA, (ADC0-R[0] in C). Follow the class notes
 * on the ADC posted on myCourses. You should use #define
 * names in the provided Exercise12_C_Stub.c file.
 */

#define ADC0_CFG1_ADIV_BY2 (2u)
#define ADC0_CFG1_MODE_SGL10 (2u)
#define ADC0_CFG1_ADICLK_BUSCLK_DIV2 (1u)
#define ADC0_CFG1_LP_LONG_SGL10_3MHZ \
		(ADC_CFG1_ADLPC_MASK | \
			(ADC0_CFG1_ADIV_BY_2 << ADC_CFG1_ADIV_SHIFT) | \
			ADC_CFG1_ADLSMP_MASK | \
			(ADC0_CFG1_MODE_SGL10 << ADC_CFG1_MODE_SHIFT) | \
			ADC0_CFG1_ADICLK_BUSCLK_DIV2)
#define ADC0_CFG2_CHAN_A_NORMAL_LONG (0x00u)
#define ADC0_SC2_REFSEL_VDDA (0x01u)
#define ADC0_SC2_SWTRIG_VDDA (ADC0_SC2_REFSEL_VDDA)
/* ADC0_SC3: Initiate calibration
 * Calibration
 */
#define ADC0_SC3_CAL (ADC_SC3_CAL_MASK | \
											ADC_SC3_AVGE_MASK | \
											ADC_SC3_AVGS_MASK)
/* ADC0_SC3: Select single conversion
 * Normal operation
 */
#define ADC0_SC3_SINGLE (0x00u)
// ADC0_SC1A: Status and Control Register for Channel A
#define ADC0_SC1_ADCH_AD23 (23u)
#define ADC0_SC1_SGL_DAC0 (ADC0_SC1_ADCH_AD23)

//Enable clock for ADC0
/* Enable ADC0 module clock */
SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;

//Configure ADC0
ADC0->CFG1 |= ADC0_CFG1_LP_LONG_SGL10_3MHZ;
ADC0->CFG2 |= ADC0_CFG2_CHAN_A_NORMAL_LONG;
ADC0->SC2 |= ADC0_SC2_SWTRIG_VDDA;

//Calibrate ADC0
ADC0->SC3 = ADC0_SC3_CAL;
while (ADC0->SC3 & ADC_SC3_CAL_MASK);
if (ADC0->SC3 | ADC_SC3_CALF_MASK == false){
//From this line until the end of this problem was educated guessing
	printf("Failure");
}
ADC0->PG |= ((ADC0_CLP0 + ADC0_CLP1 + ADC0_CLP2 + \
						ADC0_CLP3 + ADC0_CLP4 + ADC0_CLPS) \
						>> 1 | 0x8000;
ADC0->MG |= ((ADC0_CLM0 + ADC0_CLM1 + ADC0_CLM2 + \
						ADC0_CLM3 + ADC0_CLM4 + ADC0_CLMS)
						>> 1) | 0x8000;
ADC0->SC3 |= ADC0_SC3_SINGLE;

/* 3. Write C code to initialize the KL46 TPM0 to produce on channel 4 (TPM0_CH4) a
 * waveform with a 20-ms period and with a duty period of 10%, (i.e., 2 ms). Follow
 * the class notes on the TPM posted on myCourses. You should use the #define
 * names in the provided Exercise12_C_Stub.c file.
 */

#define SIM_SOPT2_TPMSRC_MCGPLLCLK (1u << \
											SIM_SOP2_TPMSRC_SHIFT)
#define SIM_SOPT2_TPM_MCGPLLCLK_DIV2 \
											(SIM_SOPT2_TPMSRC_MCGPLLCLK | \
														SIM_SOPT2_PLLFLLSEL_MASK)
#define TPM_CONF_DEFAULT (0u)
#define TPM_CNT_INIT (0u)
#define TPM_MOD_PWM_PERIOD_20ms (60000u)
#define TPM_CnSC_PWMH (TPM_CnSC_MSB_MASK | \
												TPM_CnSC_ELSB_MASK)
#define TPM_SC_CMOD_CLK (1u)
#define TPM_SC_PS_DIV16 (0x4u)
#define TPM_SC_CLK_DIV16 \
	((TPM_SC_CMOD_CLK << TPM_SC_CMOD_SHIFT) | \
												TPM_SC_PS_DIV16)

//Set SIM_CGC6 for TPM0 Clock Enabled
SIM->SCGC6 |= SIM_SCGC6_TPM0_MASK;

//Select Pin to Connect to TPM0_CH4
PORTE->PCR[31] = SET_PTE_31_TPM0_CH4;

//Select/Configure TPM Clock Source
SIM->SOPT2 &= ~SIM_SOPT2_TPMSRC_MASK;
SIM->SOPT2 |= SIM_SOPT2_TPM_MCGPLLCLK_DIV2;

TPM0->CONF = TPM_CONF_DEFAULT;
TPM0->CNT = TPM_CNT_INIT;
TPM0->MOD = TPM_MOD_PWM_PERIOD_20ms;
TPM0->CONTROLS[4].CnSC = TPM_CnSC_PWMH;
TPM0->CONTROLS[4].CnV = PWM_DUTY_5;//Not sure how to access duty table; best guess
TPM0->SC = TPM_SC_CLK_DIV16;//I think