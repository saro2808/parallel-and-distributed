#!/usr/bin/env bash

hdfs fsck -blockId $1 | grep Block > result.txt
python3 parse.py
path=$(sudo -u hdfsuser ssh "hdfsuser@$(<answer.txt)" find /dfs/ -name $1)
echo "$(<'answer.txt'):$path"
rm result.txt
rm answer.txt
