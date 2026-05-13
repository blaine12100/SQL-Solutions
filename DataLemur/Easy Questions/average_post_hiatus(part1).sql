/*
Partition by user order by date with row_number. Then for each user, get record with row_number = 1 and last record

Partitioning is the wrong approach here. Group by worked. Had to take some external help
*/

with abc as (
select user_id, abs(extract(days from min(post_date) -max(post_date))) as days_between from posts
where extract(year from post_date) = '2021'group by user_id
)

select * from abc where days_between > 0