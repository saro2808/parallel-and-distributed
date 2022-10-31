#pragma once

#define ILP 8

__global__ void KernelMul(int numElements, float* x, float* y, float* result);
