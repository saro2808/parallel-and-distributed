import matplotlib.pyplot as plt
import numpy as np

tasks = [
        "01-add",
        "02-mul",
        "03-matrix-add",
        "04-matrix-vector-mul",
        "05-scalar-mul",
        "06-cosine-vector"
        ]

f = open("../build/data.txt", 'r')

for task in tasks:
    plt.figure(figsize=(12, 6))
    plt.title('Timelapses for ' + task)
    plt.xlabel('elements count')
    plt.ylabel('timelapses')

    size_array = [0] * 6
    time_array = [0] * 6
    for i in range(6):
        contents = f.readline()
        split_contents = contents.split()
        size_array[i] = split_contents[1]
        time_array[i] = split_contents[3]
    
    f.readline()
    
    plt.plot(size_array, time_array)
    plt.show()
