from pyspark import SparkContext, SparkConf
import re

def parse_edge(s):
    user, follower = s.split("\t")
    return (int(user), int(follower))

def step(item):
    prev_v, path, next_v = item[0], item[1][0], item[1][1]
    path += ',' + str(next_v)
    return (next_v, path)

if __name__ == "__main__":
    config = SparkConf().setAppName("graph_app").setMaster("yarn")
    sc = SparkContext(conf=config)

    n = 400
    edges = sc.textFile("/data/twitter/twitter_sample.txt").map(parse_edge)
    forward_edges = edges.map(lambda e: (e[1], e[0])).partitionBy(n).persist()

    initial_vertex = 12
    terminal_vertex = 34
    paths = sc.parallelize([(initial_vertex, str(initial_vertex))]).partitionBy(n)

    count = 0
    while count < 1:
        paths = paths.join(forward_edges, n).map(step)
        count = paths.filter(lambda x: x[0] == terminal_vertex).count()

    print paths.filter(lambda x: x[0] == terminal_vertex).first()[1]
