ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
ADD FILE reverse.py;

USE arutjunjansa;

SET hive.exec.max.dynamic.partitions=10000;
SET hive.exec.max.dynamic.partitions.pernode=10000;
SET hive.exec.dynamic.partition.mode=nonstrict;

SELECT TRANSFORM(ip)
USING 'python3 reverse.py' as IP
FROM Subnets LIMIT 10;
