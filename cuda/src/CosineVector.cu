#include <CosineVector.cuh>
#include <ScalarMulRunner.cuh>
#include <cmath>
#include <iostream>

float CosineVector(int numElements, float* vector1, float* vector2, int blockSize) {
	float* d_vector1;
	float* d_vector2;
	int size = numElements * sizeof(float);
	cudaMalloc(&d_vector1, size);
	cudaMalloc(&d_vector2, size);
	cudaMemcpy(d_vector1, vector1, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_vector2, vector2, size, cudaMemcpyHostToDevice);
	float vector1_norm = sqrt(ScalarMulSumPlusReduction(numElements, d_vector1, d_vector1, blockSize));
	float vector2_norm = sqrt(ScalarMulSumPlusReduction(numElements, d_vector2, d_vector2, blockSize));
	float vector1_dot_vector2 = ScalarMulSumPlusReduction(numElements, d_vector1, d_vector2, blockSize);
	cudaFree(d_vector1);
	cudaFree(d_vector2);
	return vector1_dot_vector2 / vector1_norm / vector2_norm;
}

