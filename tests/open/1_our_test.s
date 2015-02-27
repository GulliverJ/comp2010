###### Commented out means won't work currently - NEED TO FIX

# FUNCTIONS NOT WORKING AS CANNOT SEPARATE DECLIST FROM STATEMENTLIST
#fdef foo () {
	# DecList
	#jack : int := 100;
#	shubham : bool;
	# StatementList
#	shubham := T;

#};


myRat : rat := 5_3/2;

myDict : dict<top,top> := { 's' : jack };
mySeq : seq<top> := [1,2,'A', variable];


noBug : dict<top, top> := { 's' : 2, 120 : T};
ohria : dict<int, top> := { 's' : 2, { 2.532435 : 3 } : jack, 120 : T };

shubs : seq<top> := ['s', 124324, 1.234, jack, [1,2,3], { 'a' : 1 }, "jack"];


main