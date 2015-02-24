// COMP2010 Group 9
// Coursework 1

//hey 2.0

// Version 0.1 - Basic lexer which recognises a very small subset of the final design
//	           - Should return successful parse on, for example, "a : int := 1 + 2;"

import java_cup.runtime.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();
	private Symbol symbol(int type) {
	    return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
	    return new Symbol(type, yyline, yycolumn, value);
	}
%}

Line Terminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]

// Code for handling comments
Comment = {WrappedComment} | {LineComment}

WrappedComment = "/#" [^#] ~"#/" | "/#" "#"+ "/" 
LineComment = "#" {InputCharacter}* {LineTerminator}?
CommentContent = ( [^#] | \# + [^/#])

Identifier = [:jletter:] [:jletterdigit:]*

DecIntegerLiteral = 0 | [1-9][0-9]*

//TODO: Float literal
//TODO: String content/character literals

%%

<YYINITIAL> {

	// Keywords //

	"int"					{ return symbol(sym.INT); }

	// Separators //

	";"						{ return symbol(sym.SEMI); }
	":"						{ return symbol(sym.COLON); }

	// Operators //

	"+"						{ return symbol(sym.PLUS); }
	":="					{ return symbol(sym.ASSIGN); }

	{DecIntegerLiteraL}		{ return symbol(sym.NUM, new Integer(yytext())); }
	{Identifier}			{ return symbol(sym.ID, new Integer(1)); }
	{Comment}				{ }
	{WhiteSpace}			{ }
	
}

[^]							{ System.err.println("Error in line " + yyline + " at " + yycolumn)}