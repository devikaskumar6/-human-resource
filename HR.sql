CREATE DATABASE HR;

USE HUMAN_RESOURCE;
SELECT * FROM hr;
ALTER TABLE hr
change column ï»¿id emp_id varchar(20) null;

describe hr;
select birthdate from hr;

set sql_safe_updates = 0;
update hr
set birthdate= CASE
  when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
  when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
  else null
end;  

alter table hr
modify column birthdate Date;

update hr
set hire_date= case
  when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
  when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
  else null
end;  

alter table hr
modify column hire_date date;

select birthdate from hr;
select hire_date from hr;


update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
   where termdate is not null and termdate != '';
select termdate from hr;
alter table hr
modify column termdate date;

describe hr;

alter table hr add column age int;

update hr
set age = timestampdiff(Year,birthdate,CURDATE());
select birthdate,age from hr;

select 
min(age) as youngest,
max(age)as oldest
from hr;

select count(*)from hr where age < 18;
select gender,count(*)as count
from hr
where age>=18 
group by gender;

select race,count(*) as count 
from hr
where age >=18 
group by race
order by count(*)desc;

select
min(age) as youngest,
max(age)as oldest
from hr
where age >=18 ;

select
  case
    when age>=18 and age<=24 then '18-24'
    when age>=25 and age<=34 then '25-34'
    when age>=35 and age<=44 then '35-44'
    when age>=45 and age<=54 then '45-54'
    when age>=55 and age<=64 then '55-64'
    else '65+'
   end as age_group,gender,
   count(*)as count
from hr
where age >=18 
group by age_group,gender
order by age_group,gender;

select location,count(*)as count
from hr
where age>=18
group by location;

select 
round(avg(datediff(termdate,hire_date))/365,0) as avg_lenght_employment 
from hr;

select department, gender ,count(*)as count
from hr
where age>=18
group by department, gender
order by department ,gender;

select jobtitle,count(*) as count
from hr
where age>=18
group by jobtitle
order by jobtitle desc;

select department,
total_count,
terminated_count,
terminated_count/total_count as termination_rate

from(
select department,
count(*) as total_count,
sum(case when termdate<> ' ' and termdate <= curdate()then 1 else 0 end)
from hr
where age>=18
group by department 
) as subquery
order by termination_rate desc;

select location_state,count(*) as count
from hr
where age>=18
group by location_state
order by count desc;

select
year,
hires,
terminations,
hires-terminations as net_change,
round((hires-termination)/hires*100,2)as net_change_percent
from(
     select 
	 year(hire_date)as year,
	 count(*) as hires,
     sum(case when termdate<>'0000-00-00' and termdate <= curdate()then 1 else 0 end)as terminations
  from hr
  where age >=18
  group by Year(hire_date)
  )as subquery
  order by year asc;
  
  
  
  



