/*
For this, I need to join to the phone info table twice: Once with callerid from phone_calls table and
again with receiver id. Then, the count of calls is between when the countries of both caller and receiver is 
not the same from this table vs all the calls from this table
*/

with country_data as (
select p.caller_id, p.receiver_id, ph1.country_id, ph2.country_id as second_country from phone_calls as p
left join phone_info as ph1 on p.caller_id = ph1.caller_id
left join phone_info as ph2 on p.receiver_id = ph2.caller_id
)

/*
country_data_2 as (
select c.caller_id, c.receiver_id, c.country_id, ph1.country_id as second_country from country_data as c
left join phone_info as ph1 on c.receiver_id = ph1.caller_id
)
*/

select round((sum(case when country_id != second_country then 1 else 0 end)::NUMERIC/ count(*)) * 100, 1) as international_calls_pct
 from country_data
-- */
 
 --select * from country_data