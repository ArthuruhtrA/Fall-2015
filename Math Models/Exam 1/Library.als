/**
 * The books in a library.
 */
some sig Book{}

/**
 * Patrons of the library, in general, have some books (on loan)
 * and want some other books.
 */
some sig Patron {
	has		: set Book,
	wants	: set Book
}

/**
 * The library has some books on reserve, some on the shelves,
 * and some on hold because patrons want them (are waiting for
 * them).
 *
 * Note: The books on loan are exactly those all the Patrons as
 *				a group "have".
 */
one sig Library {
	onReserve : set Book,
	onShelves	: set Book
}

/**
 *	Reserve books are always shelved (they cannot be loaned).
 *	Of course some non-reserve books *MAY* be on the shelves
 *	if no patron has them.
 */
fact F1_All_books_onReserve_are_onShelves {
	// Fill in this body
	all b: Book | b in Library.onReserve => b in Library.onShelves
}

/**
 *	All books are on the library shelves or on loan (on loan means
 *  some patron has the book).
 */
fact F2_All_books_on_shelves_or_on_loan {
	// Fill in this body
	all b: Book | b in Library.onShelves or b in Patron.has
}

/**
 *	A book cannot be both on the shelves and on loan.
 */
fact F3_No_book_onShelves_and_onHold {
	// Fill in this body
	all b: Book | (b in Library.onShelves => b not in Patron.has) and (b in Patron.has => b not in Library.onShelves)
}

/**
 *	All wanted books are on loan to some patron (that is,
 *	some patron has the wanted book). Note that a patron
 *	*MAY* have a book out that nobody else wants.
 */
fact F4_All_wanted_books_are_had_by_someone {
	// Fill in this body
	all b: Book | b in Patron.wants => b in Patron.has
}

/**
 *	Two different patrons cannot have the same book.
 */
fact F5_No_loan_conflicts {
	// Fill in this body
	all b: Book | all p, q: Patron | (b in p.has => b not in q.has) or (p = q)
}

/**
 *	No patron can want reserved books.
 */
fact F6_Patron_cannot_want_reserved_books {
	// Fill in this body
	all b: Book | b in Library.onReserve => b not in Patron.wants
}	

/**
 *	A patron cannot want a book he or she already has.
 */
fact F7_Cannot_want_what_you_have {
	// Fill in this body
	all b: Book | all p: Patron | b in p.has => b not in p.wants
}

/**
 *	This run predicate is designed to show
 *	"interesting" states.
 */
run{
	some onReserve
	some onShelves - onReserve
	some wants
	some has
	some Patron.has - Patron.wants
	some Patron.has & Patron.wants
	some has.Book & wants.Book
} for exactly 3 Patron, exactly 8 Book




















	
