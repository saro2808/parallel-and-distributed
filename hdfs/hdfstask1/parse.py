result = open('result.txt', 'r')
contents = result.readline()
while contents[0] != '0':
    contents = result.readline()
loc = contents.split(':')[1]
i = 0
while loc[i] != '_':
    i += 1
i += 1
while loc[i] != '_':
    i += 1
loc = loc[:i]
with open('new.txt', 'w') as new:
    new.write(loc)
result.close()
