/* 1. Write pseudocode to generate a random number between 0 and 3 (inclusive) to
 * determine which of the four KLED color patterns to light.
 */
Init_PIT_IRQ();
RunTimer = 1;
input =	GetChar();
RunTimer = 0;
random = count % 4;

/* 2. Write pseudocode to determine if a user had pressd a key. Unlike GetChar, this code
 * should not wait unti the user presses a key, and it should not get the character of the
 * key pressed, (i.e., it should not dequeue the character from the receive queue).
 */
bool KeyPressed(){
	if (RxQ->NumEnqueued == 0){
		return false;
	}
	else {
		return true;
	}
}
			
/* 3. Write pseudocode to compute the score for each round of the game. */
int CalculateScore(int round, int time){
	return round * 100 / time;
}