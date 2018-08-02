#include <stdio.h>
#include <stdlib.h>
char readbuffer[10000];
char buffer[10000];
long fsize;

#include <iostream>
using namespace std;

void readFile(){
    FILE * f = fopen("image.txt", "rb");
    fseek(f, 0, SEEK_END);
    fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  //same as rewind(f);
    fread(readbuffer, fsize, 1, f);
    fclose(f);
    readbuffer[fsize] = 0;
    //printf("%s",readbuffer);
}

char stringFlag = false;

void removeComments(){
    char * carrier = readbuffer;
    long i = 0;
    while ( *carrier != 0 ){
        if ( *carrier == '/' && *(carrier+1) == '/' ){
            while ( *carrier != '\n')
                *carrier++;
            *carrier++;
        }
        buffer[i] = *carrier;
        i++;
        *carrier++;
    }
}

char * parseLine( char * point ){
    char expression[1000];
    int i = 0;

    char * carrier = point;
    while ( *carrier != '\n' && *carrier != 0 ){

        if ( *carrier != ' ' ){
            expression[i] = *carrier;
        }else{
            expression[i] = 0;
            i = -1;
            cout << expression << endl;
        }
        carrier++;
        i++;
    }
    if ( i != 0 )
    cout << expression << endl;
    return carrier;
}

int main(){
    readFile();
    removeComments();

    //cout << buffer;

    char * stuff = buffer;

    for ( int i = 0; i < 4; i ++ ){
        stuff = parseLine(stuff);
        cout << "-----\n";
    }



    return 0;
}