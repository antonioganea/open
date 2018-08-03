#include <iostream>

#include "parser.h"
#include "stdlib.h"

#include "output.h"

using namespace std;

// this function is called syntax parser
// just the parser, the parse
extern int yyparse();

extern FILE* yyin;

FILE * fin;

int main()
{
	ScriptOutput::initFout();
	

	fopen_s(&fin, "input.q", "r");
	//yyin = stdin;
	yyin = fin;
	do {
		yyparse();
	} while (!feof(yyin));


	ScriptOutput::flushFout();
	system("pause");

	return 0;
}

// we have to code this function
void yyerror(const char* msg)
{
	cout <<"Error: " <<msg << endl;

}