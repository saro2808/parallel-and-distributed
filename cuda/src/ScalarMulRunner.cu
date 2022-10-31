#include <ScalarMulRunner.cuh>
#include <ScalarMul.cuh>

float ScalarMulTwoReductions(int numElements, float* vector1, float* vector2, int blockSize) {
	
	return 0.0f;
}

__global__
void BlockSum(int blocks_count, float* blocks_vector, float* d_dot_product) {
	int index = threadIdx.x;
	for (int i = index; i < blocks_count; i += blockDim.x) {
		atomicAdd(d_dot_product, blocks_vector[i]);
	}
}

float ScalarMulSumPlusReduction(int numElements, float* d_vector1, float* d_vector2, int blockSize) {
	float dot_product = 0;
	int blocksCount = (numElements + blockSize - 1) / blockSize;
	float* h_result = new float[blocksCount];
	for (int i = 0; i < blocksCount; ++i) {
		h_result[i] = 0.0f;
	}

	float* d_result;
	cudaMalloc(&d_result, blocksCount * sizeof(float));
	cudaMemcpy(d_result, h_result, blocksCount * sizeof(float), cudaMemcpyHostToDevice);

	ScalarMulBlock<<<blocksCount, blockSize>>>(numElements, d_vector1, d_vector2, d_result);
	cudaDeviceSynchronize();
	
	float* d_dot_product;
	cudaMalloc(&d_dot_product, sizeof(float));
	cudaMemcpy(d_dot_product, &dot_product, sizeof(float), cudaMemcpyHostToDevice);
	
	BlockSum<<<1, blockSize>>>(blocksCount, d_result, d_dot_product);
	cudaDeviceSynchronize();

	cudaMemcpy(&dot_product, d_dot_product, sizeof(float), cudaMemcpyDeviceToHost);
	
	cudaFree(d_dot_product);
	delete[] h_result;
	cudaFree(d_result);
	return dot_product;
}

