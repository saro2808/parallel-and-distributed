#include "KernelMatrixAdd.cuh"
#include <iostream>

#define BLOCK_SIZE 256

void FillMatrix(float* matrix, int height, int width) {
	for (int i = 0; i < height; ++i) {
		for (int j = 0; j < width; ++j) {
			if (i == j) {
				matrix[i * width + j] = 1;
			} else {
				matrix[i * width + j] = 0;
			}
		}
	}
}


int main(int argc, char* argv[]) {
	int height = 1 << strtol(argv[1], NULL, 10);
	int width = 1 << strtol(argv[2], NULL, 10);
	int matrix_size = height * width;
	int bytes_count = matrix_size * sizeof(float);
	float* h_A = new float[matrix_size];
	float* h_B = new float[matrix_size];
	float* h_C = new float[matrix_size];
	FillMatrix(h_A, height, width);
	FillMatrix(h_B, height, width);
	float* d_A;
	float* d_B;
	float* d_C;

	cudaMalloc(&d_A, bytes_count);
	cudaMalloc(&d_B, bytes_count);
	cudaMalloc(&d_C, bytes_count);
	cudaMemcpy(d_A, h_A, bytes_count, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, bytes_count, cudaMemcpyHostToDevice);

	int num_blocks = (height * width + BLOCK_SIZE - 1) / BLOCK_SIZE;

	cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
	
	KernelMatrixAdd<<<num_blocks, BLOCK_SIZE>>>(height, width, 0, d_A, d_B, d_C);
	
	cudaDeviceSynchronize();
	cudaEventRecord(stop);
        float milliseconds;
        cudaEventElapsedTime(&milliseconds, start, stop);
        std::cout << "time elapsed: " << milliseconds << std::endl;
	cudaMemcpy(h_C, d_C, bytes_count, cudaMemcpyDeviceToHost);
	
	float max_error = 0.0f;
	for (int i = 0; i < height; ++i) {
		for (int j = 0; j < width; ++j) {
			max_error = fmax(max_error, fabs(h_C[i * width + j] - (i == j ? 2.0f : 0.0f)));
		}
	}
	std::cout << "max error: " << max_error << std::endl;
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	delete[] h_A;
	delete[] h_B;
	delete[] h_C;

	return 0;
}
