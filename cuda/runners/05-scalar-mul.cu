#include <ScalarMulRunner.cuh>
#include <iostream>

#define BLOCK_SIZE 256

int main(int argc, char* argv[]) {
	int N = 1 << strtol(argv[1], NULL, 10);
	float* vector1 = new float[N];
	float* vector2 = new float[N];
	for (int i = 0; i < N; ++i) {
		vector1[i] = 1.0f;
		vector2[i] = 1.0f;
	}
	float* d_vector1;
	float* d_vector2;
	cudaMalloc(&d_vector1, N * sizeof(float));
	cudaMalloc(&d_vector2, N * sizeof(float));
	cudaMemcpy(d_vector1, vector1, N * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_vector2, vector2, N * sizeof(float), cudaMemcpyHostToDevice);

	cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
	
	float res = ScalarMulSumPlusReduction(N, d_vector1, d_vector2, BLOCK_SIZE);

	cudaDeviceSynchronize();
	cudaEventRecord(stop);
        float milliseconds;
        cudaEventElapsedTime(&milliseconds, start, stop);
        std::cout << "time elapsed: " << milliseconds << std::endl;

	std::cout << "max error: " << fabs(res - N) << std::endl;

	cudaFree(d_vector1);
	cudaFree(d_vector2);
	delete[] vector2;
	delete[] vector1;
	return 0;
}

