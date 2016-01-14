one sig Wristbook {
	accounts : set Person
}

sig Person {
	friends : set Person,
	requests : set Person
}

fact FriendsSymmetric {
	all a, b: Person | a in b.friends <=> b in a.friends
}

fact NoAccount_NoFriendsOrRequests {
	all p, q: Person | p not in Wristbook.accounts => (q not in p.friends and q not in p.requests and p not in q.requests)
}

fact NoFriendsMakeRequests {
	all p, q: Person | q in p.friends => q not in p.requests
}

fact NotFriendsOfSelf {
	all p: Person | p not in p.friends
}

fact NoRequestsOfSelf {
	all p: Person | p not in p.requests
}

run {
	some p: Person | p not in Wristbook.accounts
	some requests
	some disj p1, p2, p3 : Person {
		p1 in p2.friends
		p2 in p3.friends
		p3 in p1.friends
	}
} for 8
