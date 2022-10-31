USE arutjunjansa;

SET hive.exec.max.dynamic.partitions=1000000;
SET hive.exec.max.dynamic.partitions.pernode=1000000;

SELECT region, count(case when users.gender = 'male' then 1 end) males_count, count(case when users.gender = 'female' then 1 end) females_count
from users inner join ipregions on Users.ip = ipregions.ip
group by region;
