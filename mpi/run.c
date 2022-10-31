#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <sys/wait.h>

int main(int argc, char* argv[]) {
	int fd = open("stat.txt", O_WRONLY | O_CREAT, 0666);
	ftruncate(fd, 0);
	int N[3] = {1000, 1000000, 100000000};
	for (int i = 0; i < 3; ++i) {
		char N_i[10];
		sprintf(N_i, "%d", N[i]);
		for (int p = 1; p <= 8; ++p) {
			int fds[2];
			pipe(fds);

			char p_j[2];
			sprintf(p_j, "%d", p);
			pid_t pid = fork();
			if (pid == 0) {
				close(fds[0]);
				dup2(fds[1], 1);
				close(fds[1]);
				execlp("mpiexec", "mpiexec", "-n", p_j, "--oversubscribe", "./task_1.exe", N_i, NULL);
			} else {
				close(fds[1]);
				dup2(fds[0], 0);
				close(fds[0]);
				waitpid(pid, 0, 0);
				
				char output[300];
				read(0, output, 300);

				char* ptr_consecutive = strstr(output, "consecutive time");
				if (ptr_consecutive == NULL) {
					printf("oh nooooo\n");
					return 1;
				}
				char* ptr_eq_1 = strstr(ptr_consecutive, "= ");
				if (ptr_eq_1 == NULL) {
					printf("oh nooooo eq 1\n");
					return 1;
				}
				char* ptr_parallel = strstr(ptr_consecutive, "parallel time");
				if (ptr_parallel == NULL) {
					printf("OH NOOOOO\n");
					return 1;
				}
				char* ptr_eq_2 = strstr(ptr_parallel, "= ");
				if (ptr_eq_2 == NULL) {
					printf("OH NOOOOO eq 2\n");
					return 1;
				}
				char* end = strstr(ptr_parallel, "\n");
				int size = (int)(end - ptr_consecutive);
				
				char consecutive_time[20];
                                int consecutive_size = (int)(ptr_parallel - ptr_eq_1 - 3);
                                strncpy(consecutive_time, ptr_eq_1 + 2, consecutive_size);
				consecutive_time[consecutive_size] = '\0';

				char parallel_time[20];
				int parallel_size = (int)(end - ptr_eq_2 - 2);
				strncpy(parallel_time, ptr_eq_2 + 2, parallel_size);
				
				printf("N = %d, p = %d done\n", N[i], p);
				dprintf(fd, "%d %d %s %s\n", N[i], p, consecutive_time, parallel_time);
			}
		}
	}
	return 0;
}
