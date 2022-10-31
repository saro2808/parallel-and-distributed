#include <KernelMul.cuh>
#include <iostream>

#define BLOCK_SIZE 256

int main(int argc, char* argv[]) {
	int N = 1 << strtol(argv[1], NULL, 10);
	size_t size = N * sizeof(float);
	float *h_x = (float*)malloc(size);
	float *h_y = (float*)malloc(size);
	float *h_z = (float*)malloc(size);

	float *d_x, *d_y, *d_z;

	cudaMalloc(&d_x, size);
	cudaMalloc(&d_y, size);
	cudaMalloc(&d_z, size);

	for (int i = 0; i < N; ++i) {
		h_x[i] = 1.0f;
		h_y[i] = 2.0f;
	}


	cudaMemcpy(d_x, h_x, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, h_y, size, cudaMemcpyHostToDevice);

	int numBlocks = (N + BLOCK_SIZE - 1) / BLOCK_SIZE;

	cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
	
	KernelMul<<<numBlocks/ILP, BLOCK_SIZE>>>(N, d_x, d_y, d_z);

	cudaDeviceSynchronize();	
	cudaEventRecord(stop);
        float milliseconds;
        cudaEventElapsedTime(&milliseconds, start, stop);
        std::cout << "time elapsed: " << milliseconds << std::endl;

	cudaMemcpy(h_z, d_z, size, cudaMemcpyDeviceToHost);

	float maxError = 0.0f;
	for (int i = 0; i < N; ++i) {
		maxError = fmax(maxError, fabs(h_z[i]-2.0f));
	}
	std::cout << "max error: " << maxError << std::endl;

	cudaFree(d_x);
	cudaFree(d_y);
	cudaFree(d_z);
	free(h_x);
	free(h_y);
	free(h_z);
	return 0;
}
