open util/ordering[Step]
sig Step{}

one sig Wristbook {
	accounts : set Person -> Step
}

sig Person {
	friends : set Person -> Step,
	requests : set Person -> Step
}

pred FriendsSymmetric[st: Step] {
	all a, b: Person | a in b.friends.st <=> b in a.friends.st
}

pred NoAccount_NoFriendsOrRequests[st: Step] {
	all p, q: Person | p not in Wristbook.accounts.st => (q not in p.friends.st and q not in p.requests.st and p not in q.requests.st)
}

pred NoFriendsMakeRequests[st: Step] {
	all p, q: Person | q in p.friends.st => q not in p.requests.st
}

pred NotFriendsOfSelf[st: Step] {
	all p: Person | p not in p.friends.st
}

pred NoRequestsOfSelf[st: Step] {
	all p: Person | p not in p.requests.st
}

pred Invariant[st: Step] {
	FriendsSymmetric[st]
	NoAccount_NoFriendsOrRequests[st]
	NoFriendsMakeRequests[st]
	NotFriendsOfSelf[st]
	NoRequestsOfSelf[st]
}

pred init[st: Step] {
	no p: Person | p in Wristbook.accounts.st
}

pred init_exists[st: Step] {
	init[st] && Invariant[st]
}

assert init_closed {
	init_exists[first] => Invariant[first]
} check init_closed

//Sign up for Wristbook
pred enroll[st: Step, p: Person] {
	//Pre-conditions
	one st.next
	p not in Wristbook.accounts.st

	//Post-conditions
	let st' = st.next {
		Wristbook.accounts.st' = Wristbook.accounts.st + p
	}

	//Frame
	all a: Wristbook.accounts.st + p | a.next = a
}

assert enroll_closed {
	all st: Step, p: Person | Invariant[st] && enroll[st, p] => Invariant[st.next]
} check enroll_closed

//Delete account
pred withdraw[st: Step, p: Person] {
	//Pre-conditions
	one st.next
	p in Wristbook.accounts.st

	//Post-conditions
	let st' = st.next {
		Wristbook.accounts.st' = Wristbook.accounts.st - p
		all a: Person | a in Wristbook.accounts.st' && p not in a.friends.st' && p not in a.requests.st'
	}

	//Frame
	all a: Wristbook.accounts.st - p | a.next = a
}

assert withdraw_closed {
	all st: Step, p: Person | Invariant[st] && withdraw[st, p] => Invariant[st.next]
} check withdraw_closed

//Make a friend request
pred request[st: Step, from_p, to_p: Person] {
	//Pre-conditions
	one st.next
	from_p in Wristbook.accounts.st
	to_p in Wristbook.accounts.st
	from_p not in to_p.friends.st && to_p not in from_p.friends.st
	from_p != to_p

	//Post-conditions
	let st' = st.next {
		to_p.requests.st' =to_p.requests.st + from_p
	}

	//Frame
	all a: to_p.requests.st + from_p | a = a.next
}

assert request_closed {
	all st: Step, p, q: Person | Invariant[st] && request[st, p, q] => Invariant[st.next]
} check request_closed

//Accept a friend request
pred accept[st: Step, from_p, to_p: Person] {
	//Pre-conditions
	one st.next
	from_p in Wristbook.accounts.st
	to_p in Wristbook.accounts.st
	from_p not in to_p.friends.st && to_p not in from_p.friends.st
	from_p in to_p.requests.st
	from_p != to_p

	//Post-conditions
	let st' = st.next {
		to_p.requests.st' = to_p.requests.st - from_p
		from_p.requests.st' = from_p.requests.st - to_p
		to_p.friends.st' = to_p.friends.st + from_p
		from_p.friends.st' = from_p.friends.st + to_p
	}

	//Frame
	all a: to_p.requests.st - from_p | a = a.next
	all a: from_p.requests.st - to_p | a = a.next
	all a: to_p.friends.st + from_p | a = a.next
	all a: from_p.friends.st + to_p | a = a.next
}

assert accept_closed {
	all st: Step, p, q: Person | Invariant[st] && accept[st, p, q] => Invariant[st.next]
} check accept_closed

//Decline a friend request
pred deny[st: Step, from_p, to_p: Person] {
	//Pre-conditions
	one st.next
	from_p in Wristbook.accounts.st
	to_p in Wristbook.accounts.st
	from_p not in to_p.friends.st && to_p not in from_p.friends.st
	from_p in to_p.requests.st
	to_p not in from_p.requests.st

	//Post-conditions
	let st' = st.next {
		to_p.requests.st' = to_p.requests.st - from_p
	}

	//Frame
	all a: to_p.requests.st - from_p | a = a.next
}

assert deny_closed {
	all st: Step, p, q: Person | Invariant[st] && deny[st, p, q] => Invariant[st.next]
} check deny_closed

//Remove someone from friends
pred de_friend[st: Step, p, unf_p: Person] {
	//Pre-conditions
	one st.next
	unf_p in Wristbook.accounts.st
	p in Wristbook.accounts.st
	unf_p in p.friends.st && p  in unf_p.friends.st

	//Post-conditions
	let st' = st.next {
		p.friends.st' = p.friends.st - unf_p
		unf_p.friends.st' = unf_p.friends.st - p
	}

	//Frame
	all a: p.friends.st - unf_p | a = a.next
	all a: unf_p.friends.st - p | a = a.next
}

assert de_friend_closed {
	all st: Step, p, q: Person | Invariant[st] && de_friend[st, p, q] => Invariant[st.next]
} check de_friend_closed

run {
	init_exists[first]
}

run{
	all st:Step | Invariant[st]
}
