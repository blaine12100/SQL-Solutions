--Crime Scene report query (2 witnesses. Second witness name is Annabel Miller (person_id 16371) and lives somehwere on Franklin Avenue and first witness is Morty Schapiro (person id 14887) lives in last house on Northwstern Dr. Morty is a bit older as compared to Annabel and drives a better car than them.

/*
Investigation details

Annabell recognises the killer and saw the murder happen. They remeber the killer when they last worked out on 9th january 2018.

Matt heard the gunshot and saw a man run out. They had a get fit now gym bag (Probably goes to that gym).

Membership number started with 48Z (Gold member). Man was last seen in a car with had the
numbers H42W

There are 2 people who match this description

First is Joe Germuska, person_id 28819 and membership_id 48Z7A

Second is Jeremy Bowers, person_id 67318 and membership_id 48Z55

The murderer is Jeremy Bowers (Got it correct)

Additional Challenge

I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017.

Final killer is Miranda Priestly (Also got this right)
*/

--select * from crime_scene_report where type = 'murder' and city='SQL City' and date = 20180115 limit 10

--Second Witness Infomration

--select p.*, dl.*, i.* from person as p left join drivers_license as dl on p.license_id = dl.id left join income as i on p.ssn = i.ssn  where p.name like '%Annabel%' and p.address_street_name like '%Franklin Ave%'
              
--First Witness Information

--select p.*, dl.*, i.* from person as p left join drivers_license as dl on p.license_id = dl.id left join income as i on p.ssn = i.ssn  where p.id = 14887

--select * from person as p where p.address_street_name like '%Northwestern Dr%' order by address_number desc limit 1
  
 --Interview table info
 
 --select * from interview where person_id in (16371, 14887)
 
 --Membership data check on Jan 9th
 
 --select gfnm.* from get_fit_now_member as gfnm left join get_fit_now_check_in as gfnci on gfnm.id = gfnci.membership_id
 --where gfnm.membership_status like '%gold%' and gfnci.check_in_date = 20180109 and gfnci.membership_id like '%48Z%' 
 
 --License confirmation
 
 --select p.*, dl.* from person as p left join drivers_license as dl on p.license_id = dl.id
 --where dl.plate_number like '%H42W%' and p.id in (28819, 67318)
 
 --Real Criminal
 
 --select * from interview where person_id = 67318
 
 --Final Query
 
 select p.name, dl.*, feci.* from person as p
 left join facebook_event_checkin as feci
 on p.id = feci.person_id
 left join drivers_license as dl
 on p.license_id = dl.id
 where feci.event_name = 'SQL Symphony Concert' and feci.date between 20171201 and 20171231
 and dl.gender = 'female' and dl.height between 65 and 67 
 and dl.hair_color = 'red' and dl.car_make = 'Tesla' and dl.car_model = 'Model S'