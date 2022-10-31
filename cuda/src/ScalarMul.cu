#include <ScalarMul.cuh>
#include <stdio.h>

/*
 * Calculates scalar multiplication for block
 */
__global__
void ScalarMulBlock(int numElements, float* vector1, float* vector2, float *result) {
	int index = threadIdx.x + blockIdx.x * blockDim.x;
	int stride = blockDim.x * gridDim.x;
	for (int i = index; i < numElements; i += stride) {
		atomicAdd(result + blockIdx.x, vector1[i] * vector2[i]);
	}
	/*extern __shared__ float shared_data[];
	
	int index = threadIdx.x + blockIdx.x * blockDim.x;
        int stride = blockDim.x * gridDim.x;
printf("cp1 ");
	if (threadIdx.x == 0) {
		printf("threadIdx.x == %d\n", threadIdx.x);
		shared_data[blockIdx.x] = 0;
		__syncthreads();
	}
	
	for (int i = index; i < numElements; i += stride) {
		//printf("cp1.5 ");
                atomicAdd(shared_data + blockIdx.x, vector1[i] * vector2[i]);
		//shared_data[blockIdx.x] += vector1[i] * vector2[i];
		printf("cp1.75 ");
		__syncthreads();
        }
printf("cp2 ");
	__syncthreads();
printf("cp3 ");
	if (threadIdx.x == 0) {
		result[blockIdx.x] = shared_data[blockIdx.x];
		printf("[%d]%f ", blockIdx.x, shared_data[blockIdx.x]);
	}
	printf("returning from kernel ");*/
}

