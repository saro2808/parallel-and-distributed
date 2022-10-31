#include <MatrixMul.cuh>

__global__
void MatrixMul(int heightA, int widthA, int widthB, float *matrixA, float *matrixB, float *matrixResult) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;

	//int height = blockDim.x * gridDim.x;
	//int width = blockDim.y * gridDim.y;

	matrixResult[i * widthB + j] = .0f;

	for (int k = 0; k < widthA; ++k) {
		matrixResult[i * widthB + j] += matrixA[i * widthA + k] * matrixB[k * widthB + j];
	}
}

