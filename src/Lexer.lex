// COMP2010
// Group 10
// Coursework 1

// Version 0.4


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
	StringBuilder string = new StringBuilder();

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
Integer          = [-]* 0 | [-]* [1-9][0-9]*								// Added -* here to match, e.g. ----9
Float            = (0|-*[1-9][0-9]*)("."[0-9]+)				        //TODO - add "f" ending for float?
Rational         = [1-9]* "/" [1-9]* | [1-9]* "_" [1-9]* "/" [1-9]* | 0 | [+-]?[0-9]+
BooleanConstant  = "T" | "F"
Character        = "'" . "'"    // Altered from "'" [A-Z] "'" | "'" [a-z] "'" to include '0' ' ' etc.

Identifier       = [:jletter:] [:jletterdigit:]*
InputCharacter   = [^\r\n]

TraditionalComment = "/#" [^#]+ "#/" | "/#" "#"+ "/"
EndOfLineComment   = [#]+ {InputCharacter}* {LineTerminator}?
Comment            = {TraditionalComment} | {EndOfLineComment}

Dictionary         = "dict"
Sequence           = "seq"
StringCont         = [^\r\n\"\\]

//A state for handling sequences?
%state SEQ

//State for handling dictionaries
%state DICT

//State for handling strings (seq<char>)
%state STRING

%%

/* LEXICAL RULES */

/* Keywords */
"char"                { return symbol(sym.CHAR); }
"bool"                { return symbol(sym.BOOL); }
"int"                 { return symbol(sym.INT); }
"rat"                 { return symbol(sym.RAT); }
"float"               { return symbol(sym.FLOAT); }
"top"                 { return symbol(sym.TOP); }
<YYINITIAL> "print"   { return symbol(sym.PRINT); }
<YYINITIAL> "alias"   { return symbol(sym.ALIAS); }
<YYINITIAL> "tdef"    { return symbol(sym.TDEF); }
<YYINITIAL> "fdef"    { return symbol(sym.FDEF); }
<YYINITIAL> "main"    { return symbol(sym.MAIN); }

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

/* SEPARATORS - can be matched in any state. */
<YYINITIAL> ";" { return symbol(sym.SEMI); }
<YYINITIAL> ":"	{ return symbol(sym.COLON); }
"(" { return symbol(sym.LPAREN); }
")" { return symbol(sym.RPAREN); }
"{" { return symbol(sym.LBRACE); }
"}" { return symbol(sym.RBRACE); }
"[" { return symbol(sym.LBRACKET); }
"]" { return symbol(sym.RBRACKET); }

{WhiteSpace}             { /* Ignore */ }

{Comment}                { /* Ignore */ }

<YYINITIAL> {
	/* Operators */
	"/"   { return symbol(sym.DIV); }
	"*"   { return symbol(sym.MULT); }
	"-"   { return symbol(sym.SUBTRACT); }
	"+"   { return symbol(sym.PLUS); }
    "^"   { return symbol(sym.POW); }

	":="  { return symbol(sym.ASSIGN); }
	"="   { return symbol(sym.EQ); }
	"::"  { return symbol(sym.CONCAT); }
	"!="  { return symbol(sym.NOTEQ); }
	"<"   { return symbol(sym.LANGLE); }
	">"   { return symbol(sym.RANGLE); }
	"=>"  { return symbol(sym.IMPLIES); }
	"<="  { return symbol(sym.LTEQ); }
	"&&"  { return symbol(sym.AND); }
	"||"  { return symbol(sym.OR); }
	"!"   { return symbol(sym.NOT); }
	"len" { return symbol(sym.LEN); }
	","	  { return symbol(sym.COMMA); }

    /* String Literal */
	\"    { yybegin(STRING); string.setLength(0); }

	{Dictionary}             { yybegin(DICT); return symbol(sym.DICT); }

	{Sequence}               { yybegin(SEQ); return symbol(sym.SEQ); }

	{BooleanConstant}        { return symbol(sym.BOOLCONST, yytext().charAt(0)); }

	{Character}              { return symbol(sym.CHARCONST, yytext().charAt(0)); }

	{Integer}                { return symbol(sym.NUM, new Integer(yytext())); }

	{Float}                  { return symbol(sym.NUM, new Float(yytext())); }
	
	{Rational}               { return symbol(sym.NUM); }

	{Identifier}             { return symbol(sym.ID, new Integer(1)); }
}

<STRING> {

    \"                       { yybegin(YYINITIAL); return symbol(sym.STRING, string.toString()); }

	{StringCont}+            { string.append(yytext()); }

	"\\b"                    { string.append( '\b' ); }
    "\\t"                    { string.append( '\t' ); }
    "\\n"                    { string.append( '\n' ); }
    "\\f"                    { string.append( '\f' ); }
    "\\r"                    { string.append( '\r' ); }
    "\\\""                   { string.append( '\"' ); }
    "\\'"                    { string.append( '\'' ); }
    "\\\\"                   { string.append( '\\' ); }
}

/* LEXICAL STATE TO HANDLE SEQUENCES */
<SEQ> {
	//Deal with operators. Assignment may be independant of any state.
	";"               { yybegin(YYINITIAL); return symbol(sym.SEMI); }
	":"               { return symbol(sym.COLON); }
	":="              { return symbol(sym.ASSIGN); }
	"<"               { return symbol(sym.LANGLE); }
	">"               { return symbol(sym.RANGLE); }
    ","               { return symbol(sym.COMMA);  }

	//Handle all possible contents of the sequence.
	{Float}           { return symbol(sym.NUM, new Float(yytext())); }

	{Rational}        { return symbol(sym.NUM); }

	{Character}       { return symbol(sym.CHARCONST, yytext().charAt(0)); }

	{Integer}         { return symbol(sym.NUM, new Integer(yytext())); }

    {BooleanConstant} { return symbol(sym.BOOLCONST, yytext().charAt(0)); }

	{Identifier}      { return symbol(sym.ID, new Integer(1)); }
}

/* LEXICAL STATE TO HANDLE DICTIONARIES */
<DICT> {
	
	//Deal with operators. Assignment may be ableindependant of any state.
	";"               { yybegin(YYINITIAL); return symbol(sym.SEMI); }
	":"               { return symbol(sym.COLON); }
	":="              { return symbol(sym.ASSIGN); }
	"<"               { return symbol(sym.LANGLE); }
	">"               { return symbol(sym.RANGLE); }
    ","               { return symbol(sym.COMMA);  }

    //Deal with all possible contents of the dictionary.
	{Float}           { return symbol(sym.NUM, new Float(yytext())); }

	{Rational}        { return symbol(sym.NUM); }

	{Character}       { return symbol(sym.CHARCONST, yytext().charAt(0)); }

	{Integer}         { return symbol(sym.NUM, new Integer(yytext())); }

    {BooleanConstant} { return symbol(sym.BOOLCONST, yytext().charAt(0)); }

    {Identifier}      { return symbol(sym.ID, new Integer(1)); }
}

[^] { return symbol(sym.ERROR); }