#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

double integrand(double x) {
	return 4 / (1 + x * x);
}

double calculate_integral(int N, int p, double left_bound, double right_bound, int i) {
	double mesh = 1.0 / N;
	int interval_count = N * (i + 1) / p - N * i / p;
	double height_sum = (integrand(left_bound) + integrand(right_bound)) / 2;
	double current_abscissa = left_bound + mesh;
	for (int j = 0; j < interval_count - 1; ++j) {
		height_sum += integrand(current_abscissa);
		current_abscissa += mesh;
	}
	return height_sum * mesh;
}

typedef struct {
	double left;
	double right;
} Segment;

int main(int argc, char* argv[]) {
	int my_rank;
	int p; // process count
	int N = strtol(argv[1], NULL, 10); // partition size
	double I = 0;

	Segment segment_sent;
	Segment segment_received;	
	double I_sent;
	double I_received;
	
	MPI_Status status;

	MPI_Init(&argc, &argv);
	
	double start = MPI_Wtime();	
	
	double mesh = 1.0 / N;
	double consecutive_I = calculate_integral(N, 1, 0, 1, 0);
	
	double end_of_consecutive_part = MPI_Wtime();
	
	MPI_Comm_size(MPI_COMM_WORLD, &p);
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
	
	if (my_rank == 0) {
		for (int i = 1; i < p; ++i) {
			segment_sent.left = (i * N / p) * mesh;
			segment_sent.right = ((i + 1) * N / p) * mesh;
			MPI_Send(&segment_sent.left, 1, MPI_DOUBLE, i, i, MPI_COMM_WORLD);
			MPI_Send(&segment_sent.right, 1, MPI_DOUBLE, i, 2 * p + i, MPI_COMM_WORLD);
		}
	} else {
		MPI_Recv(&segment_received.left, 1, MPI_DOUBLE, 0, my_rank, MPI_COMM_WORLD, &status);
		MPI_Recv(&segment_received.right, 1, MPI_DOUBLE, 0, 2 * p + my_rank, MPI_COMM_WORLD, &status);
	}
	
	if (my_rank != 0) {
		I_sent = calculate_integral(N, p, segment_received.left, segment_received.right, my_rank);
		MPI_Send(&I_sent, 1, MPI_DOUBLE, 0, p + my_rank, MPI_COMM_WORLD);
	} else {
		I = calculate_integral(N, p, segment_received.left, segment_received.right, 0);
		printf("I[0] = %lf\n", I);
		for (int i = 1; i < p; ++i) {
			MPI_Recv(&I_received, 1, MPI_DOUBLE, i, p + i, MPI_COMM_WORLD, &status);
			printf("I[%d] = %lf\n", i, I_received);
			I += I_received;
		}

		printf("consecutive I = %lf\n", consecutive_I);
		printf("parallel I = %lf\n", I);

		double end = MPI_Wtime();
	
		printf("consecutive time = %lf\n", end_of_consecutive_part - start);
		printf("parallel time = %lf\n", end - end_of_consecutive_part);
	}

	MPI_Finalize();

	return 0;
}
