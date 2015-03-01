### IMPORTATNT QUESTIONS:
/#
1. Can we alias other aliases? (Currently, we do not support it)
	e.g. 	alias seq<char> string
			alias string new_string
#/

### BUGS / NEED TO FIX
/#
1. Lexer can't interpet strings inside SEQ or DICT state
bugDict : dict<int, char> := { 1 : "BUG" };
bugSeq : seq<top> := ['s', 124324, 1.234, jack, [1,2,3], { 'a' : 1 }, "BUG"];
#/

### TEST STARTS HERE...  <-----------------------------------------

# FUNCTIONS working as of the "alphaBody" update
fdef foo (a:int, b:float) {
	# DecList
	shubham : bool := T;
	
	fdef marge(a:int, b:float) { return T; } : int;
	tdef family { mother:person, father:person, children:seq<person> };
	alias seq<char> string;
	# StatementList
	return T;

};


myRat : rat := 5_3/2;
nonInit : top;
myDict : dict<top,top> := { 's' : jack };
mySeq : seq<top> := [1,2,'A', variable];

nestedDict : dict<int, top> := { 's' : 2, { 2.532435 : 3 } : jack, 120 : T };

nestedSeq : seq<top> := ['s', 124324, 1.234, jack, [1,2,3], { 'a' : 1 }];

main {

return i < 10;
};
