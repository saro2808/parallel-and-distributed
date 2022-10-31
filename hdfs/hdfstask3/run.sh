hdfs fsck $1 -files -blocks -locations > result.txt
python2 extract.py
rm result.txt
