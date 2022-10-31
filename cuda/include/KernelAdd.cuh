#pragma once

#define ILP 8

__global__ void KernelAdd(int numElements, float* x, float* y, float* result);

