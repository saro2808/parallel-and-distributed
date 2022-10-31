ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
USE arutjunjansa;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=10000;
SET hive.exec.max.dynamic.partitions.pernode=10000;

DROP TABLE IF EXISTS user_logs;
CREATE EXTERNAL TABLE user_logs (
        ip                      STRING,
        query_time              BIGINT,
        http_query_from_ip      STRING,
        page_size               SMALLINT,
        http_status_code        SMALLINT,
        client_app_info         STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = '^(\\S+)\\t{3}(\\d{8})\\S*\\t(\\S+)\\t(\\d+)\\t(\\d+)\\t(\\S+)\\s[\\S\\s].*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_logs_M';


DROP TABLE IF EXISTS Logs;
CREATE EXTERNAL TABLE Logs (
      ip			STRING,
      http_query_from_ip	STRING,
      page_size			SMALLINT,
      http_status_code		SMALLINT,
      client_app_info		STRING
)
PARTITIONED BY (query_time BIGINT)
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE Logs PARTITION (query_time)
SELECT ip, http_query_from_ip, page_size, http_status_code, client_app_info, query_time FROM user_logs;

SELECT * FROM Logs LIMIT 10;


DROP TABLE IF EXISTS Users;
CREATE EXTERNAL TABLE Users (
        ip      STRING,
        browser STRING,
        gender  STRING,
        age     TINYINT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = '^(\\S+)\\t(\\S+)\\t(\\S+)\\t(\\d+)$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_data_M';

SELECT * FROM Users LIMIT 10;


ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
USE arutjunjansa;


DROP TABLE IF EXISTS IPRegions;
CREATE EXTERNAL TABLE IPRegions (
    ip      STRING,
    region  STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = '^(\\S+)\\t([\\S\\s].*)$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/ip_data_M';

SELECT * FROM IPRegions LIMIT 10;


CREATE EXTERNAL TABLE Subnets (
      ip STRING,
      mask STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = '(\\S+)\\t(\\S+)'
)
STORED AS TEXTFILE
LOCATION '/data/subnets/variant1';

SELECT * FROM Subnets LIMIT 10;

