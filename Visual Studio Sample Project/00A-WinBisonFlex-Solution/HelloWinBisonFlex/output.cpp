#include "output.h"

#include "string.h"

FILE * ScriptOutput::fout;

std::stringstream ScriptOutput::globalScript;
std::stringstream ScriptOutput::mainScript;
std::streambuf * ScriptOutput::old;

void ScriptOutput::printInGlobal() {
	std::cout.rdbuf(globalScript.rdbuf());
}
void ScriptOutput::printInMain() {
	std::cout.rdbuf(mainScript.rdbuf());
}