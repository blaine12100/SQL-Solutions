/*
Struggled a bit on this (Early morning doesn't work for development for me :-)

Easy enough to solve with a CTE though
*/

with abc as (
SELECT policy_holder_id FROM callers group by policy_holder_id having count(*) >= 3
)

select count(distinct policy_holder_id) as policy_holder_count from abc

