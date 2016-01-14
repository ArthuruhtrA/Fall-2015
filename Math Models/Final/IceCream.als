/*
 * Persons are ordered, so there is a first, second, etc.
 * The ordering represents their position in the waiting line.
 * po/first is the person to be served next.
 */
open util/ordering[Person] as po

/*
 * Each person has a scoop of ice cream they want on their cone.
 */
abstract sig Person {
	scoop : IceCream
}

/*
 * The names of the four girls ordering ice cream.
 */
one sig Bridget, Glenda, Patricia, Viola extends Person{}

/*
 * The four types of ice cream the girls want.
 */
enum IceCream {Cherry, Coconut, Peppermint, Vanilla}

/*
 * Four helper functions to indicate the first through
 * fourth girl in line.
 */
fun firstP : Person {
	po/first
}

fun secondP : Person {
  next[firstP]
}

fun thirdP : Person {
  next[secondP]
}

fun fourthP : Person {
  next[thirdP]
}

/*
 * Each flavor is the scoop wanted by exactly
 * one of the girls.
 */
fact OneToOne {
	Person.scoop = IceCream
}

/*
 * Fact #1
 */
fact F1 {
	secondP = Glenda or secondP = scoop.Peppermint
}

/*
 * Fact #2
 */
fact F2 {
	Person = secondP + Glenda + Bridget + scoop.Vanilla
}

/*
 * Fact #3
 */
fact F3 {
	Viola = next[next[scoop.Coconut]]
}

/*
 * Fact #4
 */
fact F4 {
  Glenda.scoop = Cherry
}

/*
 * Run command - correct facts lead to a unique solution.
 */
run {} for 4

