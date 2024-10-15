--select *
--from covid_data cd

--select *
--from covid_vaccinations cv 



-- Add new column to our table
alter table covid_data 
add total_cases bigint;
-- Add values to the newly created column. We use cte to use over() clause
-- We Use over() clause with partition by location, so that we will not sum up just row after row, 
-- but rather have separate sum of total cases for each region
with cte as (
select location, date, SUM(new_cases) over(partition by location order by date) as total_cases from covid_data 
)
update covid_data 
set total_cases = cte.total_cases
from cte
where covid_data.location = cte.location and covid_data.date = cte.date;



-- Select Data that we will be using 
select location, date, total_cases, new_cases, total_deaths, population 
from covid_data
where continent is not NULL
order by 1,2;



-- Total Cases vs. Total Deaths in specific location(Ukraine)
select location, date, total_cases, total_deaths, ROUND(100.0*total_deaths/total_cases, 2) as death_percentage
from covid_data
where total_cases > 0 and location like '%Ukr%'
order by 1,2;



-- Total Cases vs. Population
select location, date, total_cases, population, ROUND(100.0*total_cases/population, 5) as infected_percentage
from covid_data
where total_cases > 0 and location = 'Ukraine'
order by 1,2;



--Highest Infection Rate vs. Population
select location, population, max(total_cases) as total_infection_count, MAX(100.0*total_cases/population) as infected_percentage
from covid_data 
where continent is not NULL
group by location, population
order by 4 desc




-- Top 10 Highest Infection Rate vs. Population
select location, population, max(total_cases) as total_infection_count, MAX(100.0*total_cases/population) as infected_percentage
from covid_data 
where continent is not NULL
group by location, population
order by 4 desc
limit 10;



--Highest Death Rate vs. Population
select location, population, max(total_deaths) as total_deaths_count, MAX(100.0*total_deaths/population) as death_percentage
from covid_data 
where continent is not NULL
group by location, population
order by 4 desc 



-- Top 10 Highest Death Rate vs. Population
select location, population, max(total_deaths) as total_deaths_count, MAX(100.0*total_deaths/population) as death_percentage
from covid_data 
where continent is not NULL
group by location, population
order by 4 desc 
limit 10;



-- Total deaths count by continent
select location, Max(total_deaths) as total_deaths_count
from covid_data 
where continent is null
group by location
order by 2 desc;



 -- Global total numbers grouped by date
select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 100.0*SUM(new_deaths)/SUM(new_cases) as death_percentage
from covid_data
where continent is not null and new_cases > 0
group by date
order by 1,2;



 -- Global total numbers 
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 100.0*SUM(new_deaths)/SUM(new_cases) as death_percentage
from covid_data
where continent is not null and new_cases > 0
order by 1,2;



-- Total Population vs vaccinations
-- Create CTE 
with popvsvac as(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) OVER(partition by cd.location order by cd.location, cd.date) as total_rolling_vaccinations
from covid_data cd
join covid_vaccinations cv on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null
order by 2,3)

-- Find vaccination percentage
select *, (100.0*total_rolling_vaccinations/population) as vaccination_percentage
from popvsvac;




-- It is also possible to make a temporary table instead of common table expression
-- Drop table expression helps to maintain the temporary database easier
drop table if exists percent_population_vaccinated;
create temporary table percent_population_vaccinated(
continent varchar(255),
location varchar(255),
date date,
population numeric,
new_vaccinations numeric,
total_rolling_vaccinations numeric
);

insert into percent_population_vaccinated (continent, location, date, population, new_vaccinations, total_rolling_vaccinations)
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) OVER(partition by cd.location order by cd.location, cd.date) as total_rolling_vaccinations
from covid_data cd
join covid_vaccinations cv on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null
order by 2,3;

select *, (100.0*total_rolling_vaccinations/population) as vaccination_percentage
from percent_population_vaccinated


-- Total numbers by continent
select continent, SUM(population) as population, SUM(total_cases) as total_cases, SUM(people_vaccinated) as people_vaccinated, SUM(people_fully_vaccinated) as people_fully_vaccinated, SUM(total_tests) as total_tests
from(
	select cv.continent, 
	cv.location,
	MAX(cd.population) as population,
	MAX(cd.total_cases) as total_cases,
	MAX(people_vaccinated) as people_vaccinated, 
	MAX(people_fully_vaccinated) as people_fully_vaccinated,
	SUM(coalesce(cv.new_tests,0)) as total_tests
	from covid_vaccinations cv 
	join covid_data cd on cd.location = cv.location and cv.date = cd.date
	where cv.continent is not null
	group by cv.continent, cv.location) as total_numbers
group by continent;



-- 1st Year vs Most Recent Year Comparison
with data_per_year as(select year, SUM(population) as population,
SUM(total_cases) as total_cases
from (select EXTRACT('year' from date) as year, continent, location, MAX(population) as population, MAX(total_cases) as total_cases
from covid_data cd 
where continent is not null
group by 1, 2, 3
order by 1,2,3)
group by year
order by 1)


select year,
population,
case when
year = 2024 then (select total_cases from data_per_year where year = 2024) - (select total_cases from data_per_year where year = 2023)
else total_cases 
end as total_per_year
from data_per_year
where year = 2020 or year = 2024;





-- Creating views to store data for visualizations
create view vis_total_numbers as
select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 100.0*SUM(new_deaths)/SUM(new_cases) as death_percentage
from covid_data
where continent is not null and new_cases > 0
group by date
order by 1,2;


create view vis_continent_death_counts as 
select location, Max(total_deaths) as total_deaths_count
from covid_data 
where continent is null
group by location
order by 2 desc;


create view vis_total_numbers_per_location as
select location, population, max(total_cases) as total_infection_count, MAX(100.0*total_cases/population) as infected_percentage,
max(total_deaths) as total_deaths_count, MAX(100.0*total_deaths/population) as death_percentage
from covid_data 
where continent is not NULL
group by location, population
order by 4 desc;


create view vis_vaccinations_data as
select *, (100.0*total_rolling_vaccinations/population) as vaccination_percentage
from percent_population_vaccinated;


create view vis_cases_vs_tests_vs_vaccinations as
select continent, SUM(population) as population, SUM(total_cases) as total_cases, SUM(people_vaccinated) as people_vaccinated, SUM(people_fully_vaccinated) as people_fully_vaccinated, SUM(total_tests) as total_tests
from(
	select cv.continent, 
	cv.location,
	MAX(cd.population) as population,
	MAX(cd.total_cases) as total_cases,
	MAX(people_vaccinated) as people_vaccinated, 
	MAX(people_fully_vaccinated) as people_fully_vaccinated,
	SUM(coalesce(cv.new_tests,0)) as total_tests
	from covid_vaccinations cv 
	join covid_data cd on cd.location = cv.location and cv.date = cd.date
	where cv.continent is not null
	group by cv.continent, cv.location) as total_numbers
group by continent;


create view vis_infection_rate_comparison as
with data_per_year as(select year, SUM(population) as population,
SUM(total_cases) as total_cases
from (select EXTRACT('year' from date) as year, continent, location, MAX(population) as population, MAX(total_cases) as total_cases
from covid_data cd 
where continent is not null
group by 1, 2, 3
order by 1,2,3)
group by year
order by 1)


select year,
population,
case when
year = 2024 then (select total_cases from data_per_year where year = 2024) - (select total_cases from data_per_year where year = 2023)
else total_cases 
end as total_per_year
from data_per_year
where year = 2020 or year = 2024;






