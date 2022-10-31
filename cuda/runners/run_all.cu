#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>


void run_task(int data_fd, const char* task, int argc) {
	int N_arr[6] = {10, 14, 18, 22, 25, 28};
	int heights[3] = {10, 14, 18};
	int widths[2] = {8, 12};
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 2; ++j) {
			int fds[2];
			pipe(fds);

			pid_t pid = fork();
			if (pid == 0) {
				close(fds[0]);
				dup2(fds[1], 1);
				close(fds[1]);
				if (argc == 1) {
					char N[20];
                        		sprintf(N, "%d", N_arr[i * 2 + j]);
					execlp(task, task, N, NULL);
				} else if (argc == 2) {
					char height[20];
					sprintf(height, "%d", heights[i]);
					char width[20];
					sprintf(width, "%d", widths[j]);
					execlp(task, task, height, width, NULL);
				}
			} else {
				close(fds[1]);
				wait(NULL);
				dup2(fds[0], 0);
				close(fds[0]);
	
				const int size = 100;
				char output[size];
				read(0, output, size);
	
				char* ptr_colon = strstr(output, ":");
				char* ptr_endl = strstr(ptr_colon, "max");
				
				int time_string_length = (int) (ptr_endl - ptr_colon - 3);
				char time_string[40];
				strncpy(time_string, ptr_colon + 2, time_string_length);
				time_string[time_string_length] = '\0';
	
				if (argc == 1) {
					dprintf(data_fd, "size %d time %s\n", N_arr[i * 2 + j], time_string);
					printf("task %s, N %d done\n", task, N_arr[i * 2 + j]);
				} else if (argc == 2) {
					dprintf(data_fd, "size %d time %s\n", heights[i] * widths[j], time_string);
					printf("task %s, height %d width %d done\n", task, heights[i],  widths[j]);
				}
			}
		}
	}
	dprintf(data_fd, "\n");
}

int main() {
	int data_fd = open("../build/data.txt", O_CREAT | O_WRONLY, 0666);
	ftruncate(data_fd, 0);
	run_task(data_fd, "./01-add", 1);
	run_task(data_fd, "./02-mul", 1);
	run_task(data_fd, "./03-matrix-add", 2);
	run_task(data_fd, "./04-matrix-vector-mul", 2);
	run_task(data_fd, "./05-scalar-mul", 1);
	run_task(data_fd, "./06-cosine-vector", 1);
	close(data_fd);
	return 0;
}
