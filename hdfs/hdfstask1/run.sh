hdfs fsck $1 -files -blocks -locations > result.txt
python3 parse.py
hdfs fsck -blockId $(<'new.txt') > info.txt
python3 find.py
rm result.txt
rm info.txt
rm new.txt
