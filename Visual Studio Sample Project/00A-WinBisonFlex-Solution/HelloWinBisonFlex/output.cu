#include <iostream>
#include <math.h>
// Kernel function to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

__global__
void subtract(int n, float *x, float *y)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] - y[i];
}

__global__
void multiply(int n, float *x, float *y)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] * y[i];
}

__global__
void divide(int n, float *x, float *y)
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] / y[i];
}

void readData( char * filePath, int maxNumbers, float* buffer ){
	FILE * pFile;
	int i = 0;
	pFile = fopen(filePath, "r");

	while ( i < maxNumbers )
	{
		int number;
		if (fscanf(pFile, "%d", &number) != 1)
			break;        // file finished or there was an error
		buffer[i] = (float)number;
		i++;
	}
	fclose(pFile);
}

void writeData( char *filePath, int maxNumbers, float* buffer ){
	FILE * pFile;
	int i = 0;
	pFile = fopen(filePath, "w");

	while ( i < maxNumbers )
	{
		fprintf(pFile, "%d ", buffer[i]);
		i++;
	}
	fclose(pFile);
}

int main(void)
{
float * a;
cudaMallocManaged(&a, 10000*sizeof(float));
float * b;
cudaMallocManaged(&b, 10000*sizeof(float));
for ( int i = 0; i < 10000; i++ )
	b[i] = 10000.0f;
for ( int i = 0; i < 10000; i++ )
	a[i] = 5.0f;
readData( "valuesA.txt", 10000, a );
writeData( "valuesC.txt", 10000, a );
{ int blockSize = 256;
int numBlocks = ( 10000 + blockSize - 1) / blockSize;
add<<<numBlocks, blockSize>>>( 10000, a, b ); 
}
cudaDeviceSynchronize();
for ( int i = 0; i < 10000; i++ )
	printf("%d ", a);
cudaFree(a);
cudaFree(b);
return 0;
}
