-- basic query to check our data
select *
from covid_data;

-- create CTE to easily refer
with basic_data as(
select location, date, population, new_cases, total_deaths, new_deaths, weekly_hosp_admissions
from covid_data
)


select location, population, SUM(total_deaths) as total_deaths, SUM(weekly_hosp_admissions) as total_hosp_admissions
from basic_data
group by location, population