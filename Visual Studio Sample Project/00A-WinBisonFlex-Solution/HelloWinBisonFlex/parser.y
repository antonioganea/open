%defines "parser.h"

%{
	#include <cmath>
	#include <cstdio>
	#include <iostream>
	#include <string>

	#include <map>

	#pragma warning (disable: 4005)
	
	// this function will be generated
	// by flex
	extern int yylex(); // lexical analyzer
	 
	 // we have to code this function
	extern void yyerror(const char*);

	using namespace std;

	int testVector[100];

	std::map<std::string, int> varnames;

	struct arrayInfo{
		int* reference;
		int size;
	};

	std::map<std::string, int*> pointernames;
%}

%token NUM
%token OURKEYWORD
%token DEFKEYWORD
%token SHOWKEYWORD
%token IDENTIFIER
%token INIT
%token ASSIGN
%token ARRAY
%token POPULATE

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
}

%left '-' '+'
%left '*' '/'

%%		/* the grammars here */

input: %empty
	| input line
	;

line: '\n'
	| exp '\n'	{ cout << " =>" << $<intValue>1 << endl; }
	| myrule { }
	; 

exp: NUM		   { $<intValue>$ = $<intValue>1; }
	| OURKEYWORD   { cout << "Indexing" << endl; }
	| exp '+' exp  { $<intValue>$ = $<intValue>1 + $<intValue>3; }
	| exp '-' exp  { $<intValue>$ = $<intValue>1 - $<intValue>3; }
	| exp '*' exp  { $<intValue>$ = $<intValue>1 * $<intValue>3; }
	| exp '/' exp  { $<intValue>$ = $<intValue>1 / $<intValue>3; }
	| '(' exp ')'  { $<intValue>$ = $<intValue>2; }
	;

myrule: DEFKEYWORD NUM NUM	{ cout << "Defining " << $<intValue>2 << " as " << $<intValue>3 << endl; testVector[$<intValue>2] = $<intValue>3; };
	  | SHOWKEYWORD IDENTIFIER { cout << varnames.find($<stringValue>2)->second << endl; }
	  | INIT IDENTIFIER { cout << "Inited " << $<stringValue>2 << endl;
						  varnames.insert(pair<string, int>($<stringValue>2, 0));
						}
	  | ASSIGN IDENTIFIER NUM { varnames.find($<stringValue>2)->second = $<intValue>3; }
	  | ARRAY IDENTIFIER NUM {	int * pointer = new int[$<intValue>3];
								pointernames.insert(pair<string, int*>($<stringValue>2, pointer));
								cout << "Allocated " << $<intValue>3 << " integers!" << endl;
							 }
	  | POPULATE {}
	  | IDENTIFIER { cout << $<stringValue>1 << endl; }
	  ;

%%
