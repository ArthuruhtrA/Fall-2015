some sig Person {
	friends : set Person,
	enemies : set Person
}

// Everyone is a friend of him or her self.
fact AreOwnFriend {
	// Fill in
	all p: Person | p in p.friends
}

// Nobody has someone else as both a friend and an enemy.
fact NoFriendsAreEnemies {
	// Fill in
	all p, q: Person | q in p.friends => q not in p.enemies// && q in p.enemies => q not in p.friends
}

// No person is his or her own enemy.
assert NotOwnEnemy {
	// Fill in
	all p: Person | p not in p.enemies
}
check NotOwnEnemy for 8

// The enemies of a person's enemies are friends
// of that person.
fact EnemyOfEnemyIsFriend {
	all p : Person, q : p.enemies {
		q.enemies in p.friends
	}
}

// A person's friends have that person as their
// friend.
fact FriendsAreSymmetric {
	// Fill in
	all p, q: Person | p in q.friends <=> q in p.friends
}

// A person's enemies have that person as their
// enemy.
fact EnemiesAreSymmetric {
	// Fill in
	all p, q: Person | p in q.enemies <=> q in p.enemies
}

run {} for exactly 5 Person

// There is exactly one person who is the enemy of
// everyone else.
pred CommonEnemy {
	// Fill in
	one p: Person | all q: Person | (p in q.enemies) or (p = q)
}
run CommonEnemy for exactly 5 Person

// Some persons have no friends other than themselves.
pred SomeLonelyPersons {
	// Fill in
	//some disj p, q: Person | p not in q.friends
	some p: Person | all q: Person | (p not in q.friends) or (p=q)
}
run SomeLonelyPersons for exactly 5 Person
