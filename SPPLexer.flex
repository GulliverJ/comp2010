
<<<<<<< HEAD

//ed
=======
//hey
>>>>>>> 1f621f5b1861bdfef509d4044d3d4c0cc8f92c39

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
Integer = 0 | [1-9][0-9]* | {NegativeInteger}
Identifier = [:jletter:] [:jletterdigit:]*
InputCharacter = [^\r\n]
BooleanConstant = "T" | "F"
Character = "'" [A-Z] "'" | "'" [a-z] "'"
NegativeInteger = "-"[1-9][0-9]*

TraditionalComment = "/#" [^#] "#/" | "/#" "#"+ "/"
EndOfLineComment = "#" {InputCharacter}* {LineTerminator}?
Comment = {TraditionalComment} | {EndOfLineComment}

Type = "bool" | "int" | "char" | "rat" | "top" | "float"
Dictionary = "dict<" {Type} "," {Type} ">"
Sequence = "seq<"{Type}">"

SequenceContent = {SeqInt} | {SeqChar} | {SeqBool} | {SeqFloat} | {SeqRat} | {SeqTop}
SeqInt = "[" [[+-]?[0-9]," "]* "]"
SeqChar = "[" ["'"[a-zA-Z]"'"," "]* "]"
SeqBool = "[" ["T" | "F"," "]* "]"
SeqFloat = "[" [[+-]?[0-9]*\.[0-9]+," "]* "]"
SeqRat = "[" [[1-9] "/" [1-9] | [1-9] "_" [1-9] "/" [1-9] | 0 | [+-]?[0-9]," "]* "]"
SeqTop = "[" [ [1-9] "/" [1-9] | [1-9] "_" [1-9] "/" [1-9] | 0 | [+-]?[0-9] | [+-]?[0-9]*\.[0-9]+ | "T" | "F" | "'"[a-zA-Z]"'" | [+-]?[0-9]," "]* "]"

//To parse rational numbers, a new state will be required.
//%STATE rational

//A state for handling Top sequences?
//%STATE topSeq

%%

/* LEXICAL RULES */

/* KEYWORDS */
<YYINITIAL> "char" { System.out.println("CHAR"); }
<YYINITIAL> "bool" { System.out.println("BOOL"); }
<YYINITIAL> "int"  { System.out.println("INT"); }
<YYINITIAL> "rat"  { System.out.println("RAT"); }
<YYINITIAL> "float" { System.out.println("FLOAT"); }
<YYINITIAL> "top" { System.out.println("TOP"); }
<YYINITIAL> "if"  { System.out.println("IF"); }
<YYINITIAL> "then"  { System.out.println("THEN"); }
<YYINITIAL> "fi"  { System.out.println("FI"); }
<YYINITIAL> "return"  { System.out.println("RETURN"); }

//FDEF prints FUNCTION

<YYINITIAL> {
	/* Operators */
	"/"  { System.out.println("DIVIDE"); }
	"*"  { System.out.println("TIMES"); }
	"-"  { System.out.println("MINUS"); }
	"+"  { System.out.println("PLUS"); }
	":=" { System.out.println("ASSIGN"); }
	"="  { System.out.println("EQ"); }

	/* Separators */
	";" { System.out.println("SEMI"); }
	":"	{ System.out.println("TYPE"); }
	"(" { System.out.println("LPAREN"); }
	")" { System.out.println("RPAREN"); }
	"{" { System.out.println(yytext()); }
	"}" { System.out.println(yytext()); }

	"fdef" { System.out.println("FUNCTION"); }

	"main" { System.out.println("MAIN"); }

	{Dictionary} { System.out.println(yytext()); }

	{Sequence} { System.out.println(yytext()); }

	{SequenceContent} { System.out.println(yytext()); }

	{BooleanConstant} { System.out.println("BOOLCONST"); }

	{Character} { System.out.println(yytext()); }

	//Use this when actually returning Integers.
	//return symbol(sym.NUM, new Integer(yytext()));
	{Integer} { System.out.println(yytext()); }

	//Use this when actually returning an identifier.
	//return symbol(sym.ID, new Integer(1));
	{Identifier} { System.out.println("ID(" + yytext() + ")"); }

	{WhiteSpace} { /* IGNORE WHITESPACE */ }

	{Comment} { /* IGNORE COMMENTS */ }
}

//[^] {throw new Error("Illegal character <" + yytext() + ">");}
