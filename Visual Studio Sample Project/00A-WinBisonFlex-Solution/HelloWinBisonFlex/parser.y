%defines "parser.h"

%{
	#include <cmath>
	#include <cstdio>
	#include <iostream>
	#include <string>

	#include <map>

	//#include "output.h"

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


	void readData( string filePath, int maxNumbers, int* buffer ){
		FILE * pFile;
		int i = 0;
		fopen_s(&pFile,filePath.c_str(), "r");

		while ( i < maxNumbers )
		{
			int number;
			if (fscanf(pFile, "%d", &number) != 1)
				break;        // file finished or there was an error
			buffer[i] = number;
			i++;
		}
		fclose(pFile);
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
%token INITIALIZE
%token FREE
%token APPLY

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
	  | ARRAY IDENTIFIER NUM {	cout << "float * " << $<stringValue>2 << ";" << endl;
								cout << "cudaMallocManaged(&" << $<stringValue>2 << ", " << $<intValue>3 << "*sizeof(float));" << endl;
							 }
	  | FREE IDENTIFIER {	cout << "cudaFree(" << $<stringValue>2 << ");" << endl; }
	  | READ FILENAME INTO IDENTIFIER  {	cout << "readData( \"" << $<stringValue>2 << "\", 10000, " << $<stringValue>4 << " );" << endl; }
	  | WRITE IDENTIFIER INTO FILENAME {	cout << "writeData( \"" << $<stringValue>4 << "\", 10000, " << $<stringValue>2 << " );" << endl; }
	  | IDENTIFIER '[' NUM ']' { int* localintptr = pointernames.find($<stringValue>1)->second;
								cout << $<stringValue>1 << "[" << $<intValue>3 << "] = " << localintptr[$<intValue>3] << endl;
							   }
	  | DUMP IDENTIFIER {	cout << "for ( int i = 0; i < 10000; i++ )" << endl;
							cout << "	printf(\"%d \", " << $<stringValue>2 <<");" << endl;
	  
						}

	  | APPLY IDENTIFIER IDENTIFIER IDENTIFIER {
	  	cout << "{ int blockSize = 256;" << endl;
		cout << "int numBlocks = ( 10000 + blockSize - 1) / blockSize;\n";
		cout << $<stringValue>2 << "<<<numBlocks, blockSize>>>( 10000, " << $<stringValue>3 << ", " << $<stringValue>4 << " ); \n}\n";
		cout << "cudaDeviceSynchronize();" << endl;
	  }

	  | INITIALIZE IDENTIFIER NUM { cout << "for ( int i = 0; i < 10000; i++ )" << endl;
		cout << "	" << $<stringValue>2 << "[i] = " << $<intValue>1 << ".0f;" << endl;
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
