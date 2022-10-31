result = open('result.txt', 'r')
current_line = result.readline()
pattern = " Total blocks"
while current_line[:len(pattern)] != pattern:
    current_line = result.readline()
print current_line.split(' ')[3].split('\t')[1]
result.close()
