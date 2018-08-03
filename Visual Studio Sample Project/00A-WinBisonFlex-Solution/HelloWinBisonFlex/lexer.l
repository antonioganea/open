%option noyywrap

%{ 
	
	#pragma warning (disable: 4005)

	#include <iostream>
	#include <cmath>

	using namespace std;

	#include "parser.h"

%}

NUMB	([0-9]+)|([0-9]*\.[0-9]+)

%%

{NUMB}			{ yylval.intValue = atoi(yytext); return NUM; }
[+*/()-\[\]]		{ return yytext[0]; }
[\n]			{ return '\n'; }
[ \t]			{ /* empty */ }
"quit"			{ yyterminate(); }
"dog"			{ return OURKEYWORD; }
"def"			{ return DEFKEYWORD; }
"show"			{ return SHOWKEYWORD; }
"init"			{ return INIT; }
"assign"		{ return ASSIGN; }
"array"			{ return ARRAY; }
"read"			{ return READ; }
"into"			{ return INTO; }
"dump"			{ return DUMP; }
"write"			{ return WRITE; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.stringValue = strdup(yytext); return IDENTIFIER; }
[a-zA-Z_][a-zA-Z0-9.]*   { yylval.stringValue = strdup(yytext); return FILENAME; }
.				/* nothing, eat up */
