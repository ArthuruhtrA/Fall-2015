/**
 *	Courses have a set of Persons enrolled, an enrollment limit,
 *	and a set of prerequisite courses.
 */
some sig Course{
	enrolled		: set Person,
	limit				: Int,
	prereqs			: set Course
}

/**
 *	Persons have a transcript of the courses they've completed.
 */
some sig Person {
	transcript	:	set Course,
}

/**
 *	Function to return the Courses Person p is taking.
 */
fun taking[p : Person] : set Course {
	enrolled.p
}

/**
 *	A Person cannot retake a Course.
 *	That is, at the Person is not enrolled in a course
 *	on the transcript).
 */
fact Cannot_Retake_Course {
	no p : Person | some p.transcript & taking[p]
}

/**
 *	For a Person to enroll in a Course, the Course's
 *	prerequisites must be on the Person's transcript.
 */
fact Must_Have_Prereqs_To_Enroll {
	all p : Person, c : taking[p] {
		c.prereqs in p.transcript
	}
}

/**
 *	The number of Persons enrolled in a Course
 *	cannot exceed the Course's limit.
 */
fact Class_Limit_Enforced {
	all c : Course | #c.enrolled <= c.limit
}

/**
 *	The enrollment limit for a Course must be
 *	strictly positive.
 */
fact Class_Limit_Postive {
	all c : Course | c.limit > 0
}

/**
 *	A Course cannot be its own prerequisite, either
 *	directly or indirectly (that is, the prerequisite
 *	graph is a DAG).
 */
fact Cannot_Be_Own_Prerequisite {
	no c : Course | c in c.^prereqs
}

/**
 *	The transcript must be consistent in that for any Course
 *	on a Person's transcript, the Course's prerequisites must
 *	also be on the transcript.
 */
fact Consistent_Transcript {
	all p : Person | p.transcript.prereqs in p.transcript
}

/**
 *	Will eventually show all legal states of up to 4
 *	Courses, up to 5 Persons, with an Int bit width
 *	of 5 (-16 .. 15).
 */
run{} for exactly 4 Course, exactly 5 Person, 5 Int

/**
 *	A restriction on the previous run statement:
 *	+	Some course must be full.
 *	+	Some course with students enrolled has some
 *		prerequisites.
 */
run{
	some c0 : Course | #c0.enrolled = c0.limit
	some c1 : Course | some c1.enrolled && some c1.prereqs
} for exactly 4 Course, exactly 5 Person, 5 Int
