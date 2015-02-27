# Current Bugs To Fix

Lex currently returns sym.RAT when it shouldn't

I've traced it to the following: (best to view it as one line)

Rational  = [1-9]* "/" [1-9]* | [1-9]* "_" [1-9]* "/" [1-9]* | 0 | [+-]?[0-9]*

It seems that the fault lies with the final part: [+-]?[0-9]*

This matches the empty string 

Sequence: match all of the followings in order
	Repeat
		AnyCharIn[ + -]
		optional
	Repeat
		AnyCharIn[ 0 to 9]
		zero or more times


# Lexer and Parser

Please your Lexer.lex and Parser.cup files into the src subdirectory.

To build, issue `make`.

To test, issue `make test`.

To run on a single test file, issue `./bin/sc tests/open/<some test>.s`
