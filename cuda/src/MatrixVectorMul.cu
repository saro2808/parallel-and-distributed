#include <MatrixVectorMul.cuh>

__global__
void MatrixVectorMul(int height, int width, float* matrix, float* vector, float* result) {
	int index = threadIdx.x + blockIdx.x * blockDim.x;
	int jndex = threadIdx.y + blockIdx.y * blockDim.y;
	int stride_i = blockDim.x * gridDim.x;
	int stride_j = blockDim.y * gridDim.y;
	for (int i = index; i < height; i += stride_i) {
		for (int j = jndex; j < width; j += stride_j) {
			result[i] += matrix[i * width + j] * vector[j];
		}
	}
}

