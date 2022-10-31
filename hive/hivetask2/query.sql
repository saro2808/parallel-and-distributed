ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
USE arutjunjansa;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000;
SET hive.exec.max.dynamic.partitions.pernode=1000;

SELECT query_time, count(query_time) count
FROM Logs
GROUP BY query_time
ORDER BY count DESC;
