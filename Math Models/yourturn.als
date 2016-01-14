
sig Person {
    loves : set Person, // q in p.loves <=> p loves q (q is a friend)
    hates : set Person  // q in p.hates <=> p hates q (q is an enemy)
}

pred EverybodyLovesSomebody{
	all p : Person | some p.loves
	//alternatively: all p : Person | some q : Person - 1 | q in p.loves
	
}
run EverybodyLovesSomebody for exactly 5 Person

pred TheEnemyOfMyEnemyIsMyFriend { // for everyone
	all p : Person | all q : Person | all r : Person | (q in p.hates && r in q.hates) => r in p.loves
}

run TheEnemyOfMyEnemyIsMyFriend for exactly 5 Person

pred OnePersonLovesEverybody {
	one p : Person | all q : Person | q in p.loves
}
run OnePersonLovesEverybody for exactly 5 Person

pred AtMostOnePersonIsUniversallyHated {
	lone p : Person | all q : Person | p in q.hates
}
run AtMostOnePersonIsUniversallyHated for exactly 5 Person

pred CantLoveandHate {
	all p: Person | no {p.hates & p.loves}
}

run CantLoveandHate for exactly 5 Person

pred CantLoveMyself {
	all p: Person | p ! in p.loves
}

pred AllOfTheAbove {
	EverybodyLovesSomebody &&
	TheEnemyOfMyEnemyIsMyFriend &&
	OnePersonLovesEverybody &&
	AtMostOnePersonIsUniversallyHated &&
	CantLoveandHate
}
run AllOfTheAbove for exactly 5 Person


assert checkifenemeyofmyenemyismyfriend {
one p: Person | p.hates.hates in p.loves
}
