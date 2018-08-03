# Q - The Language

### What's Q ?
Q is a very clean language for Quick GPU manipulations. CRUNCH GREAT AMOUNTS OF NUMBERS!

😊😊😊 EASY TO USE! 😊😊😊

### Examples
```
// Just a few examples :

// array declaration
array MyArray 10000
array MySecondArray 10000

// a sort of memset
initialize MyArray 5
initialize MySecondArray 3

// read files in just one line, and start crunching numbers
read valuesA.txt into a

// also, after processing you can store the data
write a into valuesC.txt

apply add a b // Operation done on the GPU !!!
              // ... subtract, multiply, divide

dump a // Tool for displaying contents into the console

free a
free b


// Single variable manipulations :
init myvar
assign myvar 103030123
show myvar     // -> 103030123
```

<hr>

# Q is written using _**Flex**/**Bison**_ for the Abstract Syntax Tree

# The power lies in the #**FILTERING** system!!! 💪

😍 __*Yay, paralelism!*__ 😍

<hr>

### What is the Q good for?
  + Batching operations
  + Image manipulations
  + Crunching numbers!

### How?
  Q is written as a parser to the NVidia CUDA language, that is similar to C. It is like that because the assembly code for that is NOT documented.

### Its uses
  + Generates tests quickly
  + Processes large quantities of data
  + Compiles to a little slightly modded form of C, so there can be plugin additions

### What next?
  + Custom filters
  + Array offsets
  + Specialized data types ( pixels, waveforms, polygons, meshes, etc ... )
  <hr>
