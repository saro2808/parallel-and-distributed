import sys

for line in sys.stdin:
    result = ''
    length = len(line.strip())
    for i in range(1, length + 1):
        result += line[length - i]
    print(result)
