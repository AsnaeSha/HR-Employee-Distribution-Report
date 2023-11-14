-- HR EMPLOYEE DISTRIBUTION 

-- cleaning and altering the table

describe hr;
set sql_safe_updates = 0;

-- changing birthdate
update hr
set birthdate = case
    when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    else null
    end;
    
    
alter table hr
modify column birthdate date;

-- changing hire_date
update hr
set hire_date = case
    when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    else null
    end;
    
alter table hr
modify column hire_date date;

-- 1.show the gender distribution 
select gender,count(gender) as total from hr
where termdate is null
group by gender

-- 2. what is the race distribution of the company
select race,count(race) as race_count from hr
where termdate is null
group by race

-- 3. age distribution of the company
select 
case when age>=18 and age<=24 then '18-24'
 when age>=25 and age<=34 then '28-34'
when age<=35 and age<=44 then '35-44'
when age>=45 and age<=54 then '45-54'
when age>=55 and age<=64 then '55-64'
else '65+'
end as age_distribution,
count(age)as num_of_employee from hr
where termdate is null
group by age_distribution
order by age_distribution

-- 4.how many employee work at hq and remote
select location,count(location) as no_working_employee from hr
where termdate is null
group by location

-- 5.what is the avg length of employment of employees who have terminated
select round(avg(year(termdate)- year(hire_date)),0) as len_of_employment from hr
where termdate is not null and termdate <=curdate()

-- 6.gender distribution accross the dept 
select department,gender,count(gender) as gender_count from hr
where termdate is null 
group by department,gender
order by department,gender

-- 6.gender distribution across the the jobtiitle
select jobtitle,gender,count(gender) as gender_count from hr
where termdate is null 
group by jobtitle,gender
order by jobtitle,gender

-- 7.distribution of jobtitles across the company
select jobtitle,count(jobtitle) as count from hr
where termdate is null
group by jobtitle

-- 8.which dept has the highest termination rate
select department,dept_count,term_count,round((term_count/dept_count * 100),2) as termination_rate from
(select department,count(department) as dept_count,count(case when termdate is not null and termdate<=curdate() then 1 end) as term_count from hr
group by department) hr
order by department

-- 9.distribution of employees across location state
select location_state,count(location_state) as num_of_employee from hr
where termdate is null
group by location_state

-- 9.distribution of employees across location city
select location_city,count(location_city) as num_of_employee from hr
where termdate is null
group by location_city

-- 10.how has the company employee count has changed over time based on hire and termination date
select years,total_hire,terminations,(total_hire-terminations) as net_change,round((terminations/total_hire * 100),2) as change_percent from
(select year(hire_date) as years,count(hire_date) as total_hire,count(case when termdate is not null and termdate <= curdate() then 1 end)as terminations from hr
group by year(hire_date)) hr
order by years

-- 11. what is the average tenure distribution in each department
select department,round(avg(year(termdate) - year(hire_date)),0) as avg_tenure from hr
where termdate is not null and termdate <= curdate()
group by department
