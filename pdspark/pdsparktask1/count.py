from pyspark import SparkContext, SparkConf
import re

config = SparkConf().setAppName("count").setMaster("yarn")
spark_context = SparkContext(conf=config)

def pair(x):
    lst = x.split(" ")
    return [(lst[i], lst[i+1]) for i in range(len(lst) - 1)]

rdd = spark_context.textFile("/data/wiki/en_articles_part")
rdd2 = rdd.map(lambda x: re.sub(u"\\W+", " ", x.strip().lower(), flags=re.U))
rdd3 = rdd2.flatMap(lambda x: pair(x)).filter(lambda x: unicode(x[0]) == "narodnaya")
rdd4 = rdd3.map(lambda x: (x, 1))
rdd5 = rdd4.reduceByKey(lambda a, b: a + b).sortBy(lambda a: a[1])
words_count = rdd5.take(10)

for word, count in words_count:
    item = (word[0].encode("utf8"), word[1].encode("utf8"))
    print item[0] + '_' + item[1], count
