// Version 0.2 - Basic lexer which recognises a very small subset of the final design
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
LineTerminator   = \r|\n|\r\n
WhiteSpace       = {LineTerminator} | [ \t\f]
Integer          = 0 | -* [1-9][0-9]*								// Added -* here to match, e.g. ----9
Float            = (0|-*[1-9][0-9]*)("."[0-9]+)				        //TODO - add "f" ending for float?
Identifier       = [:jletter:] [:jletterdigit:]*
InputCharacter   = [^\r\n]
BooleanConstant  = "T" | "F"
Character        = "'" [A-Z] "'" | "'" [a-z] "'"

TraditionalComment = "/#" [^#]+ "#/" | "/#" "#"+ "/"
EndOfLineComment   = "#" {InputCharacter}* {LineTerminator}?
Comment            = {TraditionalComment} | {EndOfLineComment}

Type       = "bool" | "int" | "char" | "rat" | "top" | "float"
Dictionary = "dict<" {Type} "," {Type} ">"
Sequence   = "seq<"{Type}">"

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

/* Keywords */
<YYINITIAL> "char"    { System.out.print("CHAR "); }
<YYINITIAL> "bool"    { System.out.print("BOOL "); }
<YYINITIAL> "int"     { System.out.print("INT "); }
<YYINITIAL> "rat"     { System.out.print("RAT "); }
<YYINITIAL> "float"   { System.out.print("FLOAT "); }
<YYINITIAL> "top"     { System.out.print("TOP "); }
<YYINITIAL> "print"   { System.out.print("PRINT "); }
<YYINITIAL> "alias"   { System.out.print("ALIAS "); }
<YYINITIAL> "fdef"    { System.out.print("FUNCTION "); }
<YYINITIAL> "tdef"    { System.out.print("TYPEDEF "); }
<YYINITIAL> "main"    { System.out.print("MAIN "); }


/* Control Flow */
<YYINITIAL> "if"      { System.out.print("IF "); }
<YYINITIAL> "then"    { System.out.print("THEN "); }
<YYINITIAL> "else"    { System.out.print("THEN "); }
<YYINITIAL> "fi"      { System.out.print("FI\n"); }
<YYINITIAL> "while"   { System.out.print("WHILE "); }
<YYINITIAL> "do"      { System.out.print("DO "); }
<YYINITIAL> "od"      { System.out.print("OD\n"); }
<YYINITIAL> "forall"  { System.out.print("FORALL "); }
<YYINITIAL> "in"      { System.out.print("IN "); }
<YYINITIAL> "return"  { System.out.print("RETURN "); }


<YYINITIAL> {
	/* Operators */
	"/"   { System.out.print("DIVIDE "); }
	"*"   { System.out.print("TIMES "); }
	"-"   { System.out.print("MINUS "); }
	"+"   { System.out.print("PLUS "); }
	"^"   { System.out.print("POW ");}

	","   { System.out.print("COMMA "); }
	":="  { System.out.print("ASSIGN "); }
	"="   { System.out.print("EQ "); }
	"::"  { System.out.print("CONCAT "); }
	"!="  { System.out.print("NOTEQ"); }
	"<"   { System.out.print("LANGLE "); }
	">"   { System.out.print("RANGLE "); }
	"<="  { System.out.print("LTEQ "); }
	"&&"  { System.out.print("AND "); }
	"||"  { System.out.print("OR "); }
	"!"   { System.out.print("NOT "); }
	"=>"  { System.out.print("IMPLIES "); }
//  "\""  { yybegin(STRING);}
	"len" { System.out.print("LEN "); }


	/* Separators */
	";" { System.out.print("SEMI\n"); }
	":"	{ System.out.print("TYPE "); }
	"(" { System.out.print("LPAREN"); }
	")" { System.out.print("RPAREN"); }
	"{" { System.out.println("LBRACE"); }
	"}" { System.out.println("RBRACE"); }
	"[" { System.out.print("LBRACKET "); }
	"]" { System.out.print("RBRACKET "); }

	{Dictionary}             { System.out.print(yytext() + " "); }

	{Sequence}               { System.out.print(yytext() + " "); }

	{SequenceContent}        { System.out.print(yytext() + " "); }

	{BooleanConstant}        { System.out.print("BOOLCONST "); }

	{Character}              { System.out.print(yytext() + " "); }

	//Use this when actually returning Integers.
	//return symbol(sym.NUM, new Integer(yytext()));
	{Integer}                { System.out.print(yytext() + " "); }

	{Float}                  { System.out.print(yytext() + " "); }

	//Use this when actually returning an identifier.
	//return symbol(sym.ID, new Integer(1));
	{Identifier}             { System.out.print("ID(" + yytext() + ") "); }

	{WhiteSpace}             { /* IGNORE WHITESPACE */ }

	{Comment}                { System.out.println("Comment: " + yytext());}
}

[^]	{System.out.print(" | TODO: Error with char " + yytext() + " | ");}

//[^] {throw new Error("Illegal character <" + yytext() + ">");}


//TODO

/* How are user-defined types dealt with, and where?
 * Floats with non-num characters (1.23a4)
 * State for seq
 * State for dict
 * Escape characters in a sequence of chars (string)
 */