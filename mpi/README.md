Файл `task_1.c` содержит код, который последовательно и параллельно вычисляет данный интеграл. Программа собирается командой
```
mpicc task_1.c -o task_1.exe
```
Получившийся бинарник можно запускать (хотя делать это руками не понадобится и не рекомендуется; для этого и предназначен следующий файл `run.c`) с помощью команды
```
mpiexec -n p --oversubscribe ./task_1.exe N
```
где `p` - количество процессов, `N` - количество отрезков разбиения для вычисления интеграла.
Файл `run.c` содержит код, который для данных значений `N` и `p` запускает `task_1.exe` и результаты сохраняет в файл `stat.txt`. Собирается и запускается этот файл командами
```
gcc run.c -o run.exe
./run.exe
```
Наконец, скрипт `plot.py` на основе данных `stat.txt` рисует три графика, которые хранятся в директории `figures`.
