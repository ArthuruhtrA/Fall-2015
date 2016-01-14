/*********************************************************************/
/* Provides control via CLI                                          */
/* Written in mixed Assembly and C                                   */
/* Name:  Ari Sanders                                                */
/* Date:  11/30/2015                                                 */
/* Class:  CMPE 250                                                  */
/* Section:  Lab 04                                                  */
/*-------------------------------------------------------------------*/
/* Template:  R. W. Melton                                           */
/*            November 16, 2015                                      */
/*********************************************************************/
#include "MKL46Z4.h"
#include "Exercise13_C.h"

#define FALSE      (0)
#define TRUE       (1)

#define MAX_STRING (79)

int			*counter = &Count;
int			*timing = &RunTimer;
char		*RxQ = &RxQRecord;

int isKeyPressed(void){
	if (RxQ[17] == 0){
		return FALSE;
	}
	return TRUE;
}

int CalculateScore(int round){
	return round * 100 / *counter;
}

int Random(void){
	int temp = *counter;
	return (*counter + temp) % 4 + *counter + RxQ[13] % 4;
}

int main (void) {
	int score;
	char input;
	char color[4][6] = {"red", "green", "both", "none"};
	int rand;
	int i;
  __asm("CPSID   I");  /* mask interrupts */
  /* Perform all device initialization here */
  /* Before unmasking interrupts            */
  Init_UART0_IRQ();
	Init_PIT_IRQ();
	*timing = 0;
	Init_LED();
  __asm("CPSIE   I");  /* unmask interrupts */
	
  for (;;) { /* do forever */
		score = 0;
		//1 Output instructions
		PutStringSB("Instructions", MAX_STRING);
		PutCRLF();
		//2 Wait for a key
		PutStringSB("Press any key to start.", 24);	
		while (!isKeyPressed()){}
		GetChar();
		//3 Play game
		for (i = 0; i < 11; i++){
			//a
			rand = Random();
			if (rand == 0){				//Red
				LED(0,1);		//Red on
				LED(1,0);		//Green off
			}
			else if (rand == 1){	//Green
				LED(0,0);		//Red off
				LED(1,1);		//Green on
			}
			else if (rand == 2){	//Both
				LED(0,1);		//Red on
				LED(1,1);		//Green on
			}
			else {								//None
				LED(0,0);		//Red off
				LED(1,0);		//Green off
			}
			//b
			PutCRLF();
			PutChar('>');
			//c
			*counter = 0;
			*timing = 1;
			while (!isKeyPressed() && *counter < (1100 - (i * 100))){}
			*timing = 0;
			input = GetChar();
			//d
			if (*counter > 11 - i){
				PutChar(input);
				if (input == color[rand][0]){
					PutStringSB("Correct--color was ", 20);
					PutStringSB(color[rand], 6);
					score += CalculateScore(i);
				}
				else {
					PutStringSB("Wrong", 6);
					if (score > 10){
						score -= 10;
					}
					else {
						score = 0;
					}
				}
			}
			//e
			else {
				PutStringSB("Out of time--color was ", 24);
				PutStringSB(color[rand], 6);
				if (score > 5){
					score -= 5;
				}
				else {
					score = 0;
				}
			}
			PutCRLF();
		}
		//4 Output score
		PutStringSB("Score: ", 8);
		PutNumUB(score);
		PutCRLF();
		//5 Repeat
  } /* do forever */

  //return (0); Not possible to reach
} /* main */
