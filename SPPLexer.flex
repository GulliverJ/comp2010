
// Version 0.1 - Basic lexer which recognises a very small subset of the final design
//	           - Should return successful parse on, for example, "a : int := 1 + 2;"

/* NEEDED FOR PARSER INTERFACING */
//import java_cup.runtime.*;

%%

//Generated class will be called Lexer.java.
%class Lexer

//Use unicode.
%unicode

//Turns on CUP compatability.
//%cup

//Allows accessing of line and column values of current token.
%line
%column

//Used when not interfacing with CUP.
%standalone

/* USED FOR GENERATING SYMBOLS USED BY THE PARSER */
/*
%{
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}
*/

/* REGULAR EXPRESSIONS */
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]
Integer = 0 | [1-9][0-9]*
Identifier = [:jletter:] [:jletterdigit:]*
InputCharacter = [^\r\n]
BooleanConstant = T | F
Char = "'" [A-Z] "'" | "'" [a-z] "'"

TraditionalComment = "/#" [^#] "#/" | "/#" "#"+ "/"
EndOfLineComment = "#" {InputCharacter}* {LineTerminator}?
Comment = {TraditionalComment} | {EndOfLineComment}

Keyword = "bool" | "int" | "char" | "rat" | "top" | "float"
Dictionary = "dict<"{Keyword}","{Keyword}">"
Sequence = "seq<"{Keyword}">"


%%

/* LEXICAL RULES */

/* KEYWORDS */
<YYINITIAL> "char" { System.out.println("Found a char at: " + yyline + " " + yycolumn); }
<YYINITIAL> "bool" { System.out.println("Found a bool at: " + yyline + " " + yycolumn); }
<YYINITIAL> "int"  { System.out.println("Found an int at: " + yyline + " " + yycolumn); }
<YYINITIAL> "rat"  { System.out.println("Found a rational at: " + yyline + " " + yycolumn); }
<YYINITIAL> "float" { System.out.println("Found a float at: " + yyline + " " + yycolumn); }
<YYINITIAL> "top" { System.out.println("Found a top at: " + yyline + " " + yycolumn); }

//FDEF prints FUNCTION

<YYINITIAL> {
	/* Operators */
	"/"  { System.out.println("Found a / at: " + yyline + " " + yycolumn); }
	"*"  { System.out.println("Found a * at: " + yyline + " " + yycolumn); }
	"-"  { System.out.println("Found a - at: " + yyline + " " + yycolumn); }
	"+"  { System.out.println("Found a + at: " + yyline + " " + yycolumn); }
	":=" { return symbol(sym.ASSIGN); }

	/* Separators */
	";" { System.out.println("Found a ; at: " + yyline + " " + yycolumn); }
	":"	{ return symbol(sym.COLON); }
	"(" { System.out.println("Found a ( at: " + yyline + " " + yycolumn); }
	")" { System.out.println("Found a ) at: " + yyline + " " + yycolumn); }

	{Integer} { return symbol(sym.NUM, new Integer(yytext())); }

	{Identifier} { return symbol(sym.ID, new Integer(1)); }

	{Dictionary} { System.out.println("Found a Dictionary at: " + yyline + " " + yycolumn); }

	{Sequence} { System.out.println("Found a Sequence at: " + yyline + " " + yycolumn); }

	{WhiteSpace} {}

	{Comment} {}
}
//[^] {throw new Error("Illegal character <" + yytext() + ">");}