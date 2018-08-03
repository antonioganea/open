%defines "parser.h"

%{
	#include <cmath>
	#include <cstdio>
	#include <iostream>
	#include <string>

	#include <map>

	#include "output.h"

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


	#include <fstream>

	void readData( string filePath, int maxNumbers, int* buffer ){
		ifstream iFile(filePath);
		int x;
		if( iFile.eof() ) return;
		int i = 0;
		while (i < maxNumbers) {
			iFile >> x;
			//cout << x << endl;
			buffer[i] = x;
			if( iFile.eof() ) break;
			i++;
		}
		iFile.close();
	}

	void writeData( string filePath, int maxNumbers, int* buffer ){
		FILE * pFile;
		int i = 0;
		fopen_s(&pFile,filePath.c_str(), "w");

		while ( i < maxNumbers )
		{
			fprintf(pFile, "%d ", buffer[i]);
			i++;
		}
		fclose(pFile);
	}

%}

%token NUM
%token OURKEYWORD
%token DEFKEYWORD
%token SHOWKEYWORD
%token IDENTIFIER
%token INIT
%token ASSIGN
%token ARRAY
%token READ
%token INTO
%token DUMP
%token FILENAME
%token WRITE
%token TEST
%token FILTER
%token RIGHT_ARROW
%token SEMI

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
	| myrule
	| exp '\n'	{ cout << " =>" << $<intValue>1 << endl; }
	;
	
myrule: DEFKEYWORD NUM NUM	{ cout << "Defining " << $<intValue>2 << " as " << $<intValue>3 << endl; testVector[$<intValue>2] = $<intValue>3; };
	  | TEST { }
	  | FILTER IDENTIFIER SEMI IDENTIFIER IDENTIFIER RIGHT_ARROW exp { 
		/*ScriptOutput::printInGlobal();
		cout << "void " << $<stringValue>2 << "(int n, float *" << $<stringValue>4 << ", float *" << $<stringValue>5 << "){" << endl;
		cout << "int index = blockIdx.x * blockDim.x + threadIdx.x;" << endl;
		cout << "int stride = blockDim.x * gridDim.x;" << endl;
		cout << "for (int i = index; i < n; i += stride)" << endl;
		cout << "	" << $<stringValue>4 << "[i] = " << $<stringValue>8 << ";" << endl << "}" << endl;*/
		}
	  | SHOWKEYWORD IDENTIFIER { cout << varnames.find($<stringValue>2)->second << endl; }
	  | INIT IDENTIFIER { cout << "Inited " << $<stringValue>2 << endl;
						  varnames.insert(pair<string, int>($<stringValue>2, 0));
						}
	  | ASSIGN IDENTIFIER NUM { varnames.find($<stringValue>2)->second = $<intValue>3; }
	  | ARRAY IDENTIFIER NUM {	int * pointer = new int[$<intValue>3];
								pointernames.insert(pair<string, int*>($<stringValue>2, pointer));
								cout << "Allocated " << $<intValue>3 << " integers! " << pointer << endl;
							 }
	  | READ FILENAME INTO IDENTIFIER  {	
											cout << "reading " << $<stringValue>2 << " into " << $<stringValue>4 << endl;
											int* localintptr = pointernames.find($<stringValue>4)->second;
											readData( $<stringValue>2, 100, localintptr );
										}
	  | WRITE IDENTIFIER INTO FILENAME {
											cout << "writing" << $<stringValue>2 << " into " << $<stringValue>4 << endl;
											int* localintptr = pointernames.find($<stringValue>2)->second;
											writeData( $<stringValue>4, 100, localintptr );
									   }
	  | IDENTIFIER '[' NUM ']' { int* localintptr = pointernames.find($<stringValue>1)->second;
								cout << $<stringValue>1 << "[" << $<intValue>3 << "] = " << localintptr[$<intValue>3] << endl;
							   }
	  | DUMP IDENTIFIER {int* localintptr = pointernames.find($<stringValue>2)->second;
						for ( int i = 0; i < 9; i++ )
							cout << '	' << localintptr[i] << endl;
	  
						}
	  | IDENTIFIER { cout << $<stringValue>1 << endl; }
	  ;

exp: NUM		   { $<intValue>$ = $<intValue>1; }
	| OURKEYWORD   { cout << "Indexing" << endl; }
	| exp '+' exp  { $<intValue>$ = $<intValue>1 + $<intValue>3; }
	| exp '-' exp  { $<intValue>$ = $<intValue>1 - $<intValue>3; }
	| exp '*' exp  { $<intValue>$ = $<intValue>1 * $<intValue>3; }
	| exp '/' exp  { $<intValue>$ = $<intValue>1 / $<intValue>3; }
	| '(' exp ')'  { $<intValue>$ = $<intValue>2; }
	;



%%
