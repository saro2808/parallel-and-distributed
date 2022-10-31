import matplotlib.pyplot as plt
import numpy as np

P_MAX = 8

f = open('stat.txt', 'r')

for N in [1000, 1000000, 100000000]:
    S = [0] * (P_MAX + 1)
    for p in range(1, P_MAX + 1):
        contents = f.readline()
        split_contents = contents.split()
        T_0 = float(split_contents[2])
        T_p = float(split_contents[3])
        S[p] = T_0 / T_p

    p = np.arange(0, P_MAX + 1)
    plt.figure(figsize=(16, 6))
    plt.title(f'Speedup when N = {N}')
    plt.xlabel('Process count')
    plt.ylabel('Speedup')
    plt.legend(loc=1)
    plt.plot(p, S)
    plt.show()


        
