#pragma once

#include <stdio.h>
#include <iostream>

#include <sstream>

class ScriptOutput {
public:
	static FILE * fout;

	static std::stringstream globalScript;
	static std::stringstream mainScript;
	static std::streambuf * old;

	

	static void printInGlobal();
	static void printInMain();

	static void initFout() {
		int i = 0;
		old = std::cout.rdbuf(globalScript.rdbuf());


		printInGlobal();
		std::cout << "#include <iostream>\n#include <math.h>" << std::endl;

		printInMain();
		std::cout << "int main(void){\n";
	}

	static void flushFout() {
		std::string global = globalScript.str();
		std::string main = mainScript.str();

		fprintf(fout, global.c_str());
		fprintf(fout, "\n");
		fprintf(fout, main.c_str());
		fprintf(fout, "\nreturn 0;\n}\n");
		fclose(fout);
	}
private:
	ScriptOutput();
};