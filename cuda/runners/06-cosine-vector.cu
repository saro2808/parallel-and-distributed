#include <CosineVector.cuh>
#include <iostream>

#define BLOCK_SIZE 256

int main(int argc, char* argv[]) {
	int N = 1 << strtol(argv[1], NULL, 10);
	float* vector1 = new float[N];
	float* vector2 = new float[N];
	for (int i = 0; i < N; ++i) vector1[i] = vector2[i] = 1;
	cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
        
	int cosine = CosineVector(N, vector1, vector2, BLOCK_SIZE);
	
	cudaDeviceSynchronize();
	cudaEventRecord(stop);
        float milliseconds;
        cudaEventElapsedTime(&milliseconds, start, stop);
        std::cout << "time elapsed: " << milliseconds << std::endl;

        std::cout << "max error: " << fabs(cosine - 1) << std::endl;
	delete[] vector1;
	delete[] vector2;
}

