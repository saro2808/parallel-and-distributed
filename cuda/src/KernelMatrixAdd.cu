#include <KernelMatrixAdd.cuh>
#include <stdio.h>

__global__ void KernelMatrixAdd(int height, int width, int pitch, float* A, float* B, float* result) {
	int index = blockDim.x * blockIdx.x + threadIdx.x;
	int jndex = blockDim.y * blockIdx.y + threadIdx.y;
	int stride_i = blockDim.x * gridDim.x;
	int stride_j = blockDim.y * gridDim.y;
	for (int i = index; i < height; i += stride_i) {
		for (int j = jndex; j < width; j += stride_j) {
			result[i * width + j] = A[i * width + j] + B[i * width + j];
		}
	}
}

