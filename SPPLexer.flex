// COMP2010
// Group 10
// Coursework 1

// Version 0.2 - Covers majority of basic syntax; lots left to do (dict and seq need work etc.)
//             - Some minor bug fixes


import java_cup.runtime.*;

%%

//Generated class will be called Lexer.java.
%class Lexer

//Use unicode.
%unicode

//Toggle CUP compatability.
%cup

//Allows accessing of line and column values of current token.
%line
%column

//Used when not interfacing with CUP.
//%standalone

%{
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

/* REGULAR EXPRESSIONS */
LineTerminator   = \r|\n|\r\n
WhiteSpace       = {LineTerminator} | [ \t\f]
Integer          = 0 | [1-9][0-9]* | {NegativeInteger}
Float            = (0|[1-9][0-9]*)("."[0-9]+)           //TODO - add "f" ending for float?
Identifier       = [:jletter:] [:jletterdigit:]*
InputCharacter   = [^\r\n]
BooleanConstant  = "T" | "F"
Character        = "'" [A-Z] "'" | "'" [a-z] "'"
NegativeInteger  = "-"[1-9][0-9]*

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
<YYINITIAL> "char"    { return symbol(sym.CHAR); }
<YYINITIAL> "bool"    { return symbol(sym.BOOL); }
<YYINITIAL> "int"     { return symbol(sym.INT); }
<YYINITIAL> "rat"     { return symbol(sym.RAT); }
<YYINITIAL> "float"   { return symbol(sym.FLOAT); }
<YYINITIAL> "top"     { return symbol(sym.TOP); }
<YYINITIAL> "print"   { return symbol(sym.PRINT); }

/* Control Flow */
<YYINITIAL> "if"      { return symbol(sym.IF); }
<YYINITIAL> "then"    { return symbol(sym.THEN); }
<YYINITIAL> "else"    { return symbol(sym.ELSE); }
<YYINITIAL> "fi"      { return symbol(sym.FI); }
<YYINITIAL> "while"   { return symbol(sym.WHILE); }
<YYINITIAL> "do"      { return symbol(sym.DO); }
<YYINITIAL> "od"      { return symbol(sym.OD); }
<YYINITIAL> "forall"  { return symbol(sym.FORALL); }
<YYINITIAL> "in"      { return symbol(sym.IN); }
<YYINITIAL> "return"  { return symbol(sym.RETURN); }

<YYINITIAL> {
	/* Operators */
	"/"  { return symbol(sym.DIV); }
	"*"  { return symbol(sym.MULT); }
	"-"  { return symbol(sym.SUBTRACT); }
	"+"  { return symbol(sym.PLUS); }
	":=" { return symbol(sym.ASSIGN); }
	"="  { return symbol(sym.EQ); }
	"!=" { return symbol(sym.NOTEQ); }
	"<"  { return symbol(sym.LTHAN); }
	">"  { return symbol(sym.GTHAN); }
	"&&" { return symbol(sym.AND); }
	"||" { return symbol(sym.OR); }

	/* Separators */
	";" { return symbol(sym.SEMI); }
	":"	{ return symbol(sym.COLON); }
	"(" { return symbol(sym.LPAREN); }
	")" { return symbol(sym.RPAREN); }
	"{" { return symbol(sym.LBRACE); }
	"}" { return symbol(sym.RBRACE); }
	"[" { return symbol(sym.LBRACKET); }
	"]" { return symbol(sym.RBRACKET); }

	"fdef"                   { return symbol(sym.FUNCTION); }

	"main"                   { return symbol(sym.MAIN); }

	{Dictionary}             { return symbol(sym.DICT); }

	{Sequence}               { return symbol(sym.SEQ); }

	{BooleanConstant}        { return symbol(sym.BOOLCONST); }

	{Character}              { return symbol(sym.CHAR); }

	{Integer}                { return symbol(sym.NUM, new Integer(yytext())); }

	{Float}                  { return symbol(sym.NUM, new Float(yytext())); }

	{Identifier}             { return symbol(sym.ID, new Integer(1)); }

	{WhiteSpace}             { /* Ignore */ }

	{Comment}                { /* Ignore */ }
}

[^] {throw new Error("Illegal character <" + yytext() + ">");}