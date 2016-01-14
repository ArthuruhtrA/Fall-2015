/* Least Common Multiple - LCM */

byte gcd = 0 ;


proctype LCM( byte ox ; byte oy ) {

	byte lcm = 0;
	byte temp = 0 ;
	byte x = ox ;
	byte y = oy ;

	do
	:: x > y -> temp = y ; 
				y = x - y ; 
				x = temp ;
		:: x < y -> temp = x ; x = y - x ; y = temp ;
	:: x == y -> break ;
	od ;

	gcd = x ;


	lcm = ox * oy / gcd;

	printf("LCM of %d and %d is %d\n", ox, oy, lcm) ;
}

init {
	run LCM(2, 4) ;
}
