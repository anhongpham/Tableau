Installation: Password, Port 5432, NEXT everything else.

/*
Objectives:
Get data of patients that had Flu shots in 2022
1. Get patients' information:
	a. Age
	b. Race
	c. County
	d. Name
	
2. Show whether or not patients received the flu shots in 2022

3. Patient must have been "Active at our hospital"
	a. Visited the hospital at least once in 2022
	b. Not dead 
*/


Point out the related column while checking the tables
Asterisk
1. Get the patients info
Check the total rows
Case-insensitive
Finish the 1st requirement

5. the flu_shot_2022 temp table will give us all the patients that got the flu shot
6. pull up the earlist date instead
7. base on the patient column from flu temp table to identify which patients got the flu shot and those who did not
8. Last req has 2 conditions:
	-Visited the hospital at least once in 2022
	-Must be alive
9. active_patients cte, use only one "WITH"
	- distinct


with active_patient as
(
	select distinct patient
	from encounters as e
	join patients as pat
	on e.patient = pat.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	and pat.deathdate is null
)

,flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022
from immunizations
where code = '5302' 
and date between '2022-01-01 00:00:00' and '2022-12-31 23:59:59'
group by patient
)

select 	 birthdate
		,race
		,county
		,"id"
		,"first"
		,"last"
		,flu.patient
		,case when flu.patient is not null then 1
		else 0
		end as flu_shot_2022
from patients pat
left join flu_shot_2022 flu
on pat.id = flu.patient
where pat.id in (select patient from active_patient)