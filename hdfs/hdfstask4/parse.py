result = open('result.txt', 'r')
current_line = result.readline()
pattern = 'Block replica on datanode'
while current_line[:len(pattern)] != pattern:
    current_line = result.readline()
with open('answer.txt', 'w')  as answer:
    answer.write(current_line.split(' ')[4].split('/')[0])
result.close()
