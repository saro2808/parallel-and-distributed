#include <MatrixVectorMul.cuh>
#include <iostream>

#define BLOCK_SIZE 256

int main(int argc, char* argv[]) {
	int height = 1 << strtol(argv[1], NULL, 10);
	int width = 1 << strtol(argv[2], NULL, 10);
	int matrix_size = height * width;
	int bytes_count = matrix_size * sizeof(float);
	
	float* matrix = new float[matrix_size];
	float* vector = new float[width];
	float* result = new float[height];
	
	for (int i = 0; i < height; ++i) {
		for (int j = 0; j < width; ++j) {
			matrix[i * width + j] = (i == j) ? 1 : 0;
		}
		result[i] = 0;
	}
	for (int j = 0; j < width; ++j) vector[j] = 1;
	
	float* d_matrix;
	float* d_vector;
	float* d_result;
	
	cudaMalloc(&d_matrix, bytes_count);
	cudaMalloc(&d_vector, width * sizeof(float));
	cudaMalloc(&d_result, height * sizeof(float));
	
	cudaMemcpy(d_matrix, matrix, bytes_count, cudaMemcpyHostToDevice);
	cudaMemcpy(d_vector, vector, width * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_result, result, height * sizeof(float), cudaMemcpyHostToDevice);
	
	int blocksNum = (matrix_size + BLOCK_SIZE - 1) / BLOCK_SIZE;
	
	cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        cudaEventRecord(start);
	
	MatrixVectorMul<<<blocksNum, BLOCK_SIZE>>>(height, width, d_matrix, d_vector, d_result);
	
	cudaDeviceSynchronize();
        cudaEventRecord(stop);
        float milliseconds;
        cudaEventElapsedTime(&milliseconds, start, stop);
        std::cout << "time elapsed: " << milliseconds << std::endl;
	
	cudaMemcpy(result, d_result, height * sizeof(float), cudaMemcpyDeviceToHost);
	
	float max_error = 0.0f;
	for (int i = 0; i < height; ++i) {
		max_error = fmax(max_error, fabs(result[i] - (i < width ? 1.0f : 0.0f)));
	}
	std::cout << "max error: " << max_error << std::endl;

	cudaFree(d_result);
	cudaFree(d_matrix);
	cudaFree(d_vector);
	delete[] result;
	delete[] vector;
	delete[] matrix;
}

