info = open('info.txt', 'r')
line = info.readline()
str = 'Block replica on datanode'
while line[:len(str)] != str:
    line = info.readline()
loc = line.split(' ')[4]
print(loc.split('/')[0])
info.close()
