#include <iostream>

#include "parser.h"
#include "stdlib.h"

//#include "output.h"

using namespace std;

// this function is called syntax parser
// just the parser, the parse
extern int yyparse();

extern FILE* yyin;

FILE * fin;

int main()
{
	//ScriptOutput::initFout();


	fopen_s(&fin, "input.q", "r");

	freopen("myfile2.txt", "w", stdout);


	FILE *f = fopen("beginning.txt", "rb");
	fseek(f, 0, SEEK_END);
	long fsize = ftell(f);
	fseek(f, 0, SEEK_SET);  //same as rewind(f);

	char *internBuffer = (char*)malloc(fsize + 1);
	fread(internBuffer, fsize, 1, f);
	fclose(f);

	internBuffer[fsize] = 0;

	puts(internBuffer);

	//yyin = stdin;
	yyin = fin;
	do {
		yyparse();
	} while (!feof(yyin));


	//ScriptOutput::flushFout();
	//system("pause>nul");

	cout << "return 0;" << endl << '}' << endl;

	return 0;
}

// we have to code this function
void yyerror(const char* msg)
{
	cout <<"Error: " <<msg << endl;

}