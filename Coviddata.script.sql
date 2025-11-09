select *
from coviddeaths c 
order by 3,4

select *
from covidvaccinations c 
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths c 
order by 3,4

--Looking at total cases vs total deaths 
SELECT location,
       date,
       total_cases,
       total_deaths,
       
       CASE
           WHEN total_cases > 0 THEN (total_cases::numeric / total_deaths::numeric) * 100
           ELSE NULL
       END AS deathpercentage
FROM coviddeaths c
where location LIKE '%United States%'
ORDER BY 1,2;

--Total cases vs Population 
SELECT location,
       date,
       Population,
       total_cases,
       
       
       CASE
           WHEN total_cases > 0 THEN (total_cases::numeric / Population::numeric) * 100
           ELSE NULL
       END AS deathpercentage
FROM coviddeaths c
where location LIKE '%United States%'
ORDER BY 1,2;

--Countries with Highest Infection Rate compared to Population 
SELECT location,
       date,
       Population,
      MAX(total_cases) as HighestInfectionCount,
       
       
       CASE
           WHEN MAX(total_cases) > 0 THEN MAX((total_cases::numeric / Population::numeric)) * 100
           ELSE NULL
       END AS PercentPopulationInfected
FROM coviddeaths c
where location LIKE '%United States%'
group by location,date,population
ORDER BY 1,2;

--Countries with Highest Death Count per Population
SELECT location,
      MAX(CAST(total_deaths as int)) as TotalDeathCount 
FROM coviddeaths c
group by location
ORDER BY 1,2 desc

--Continents with the highest death count per population
SELECT c.continent,
      MAX(CAST(total_deaths as int)) as TotalDeathCount 
FROM coviddeaths c
--Where location like '%states%'
where continent is not null
group by continent
ORDER BY TotalDeathCount desc

--Global Numbers
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS int)) AS total_deaths,
    CASE 
        WHEN SUM(new_cases) > 0 
        THEN (SUM(CAST(new_deaths AS numeric)) / SUM(new_cases)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM coviddeaths c 
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2

--Total Population vs Vaccination
with PopVsVac (Continent, location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(nullif(vac.new_vaccinations,'') as numeric))
 OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not NULL
--order by 2,3
)
select *, (rollingpeoplevaccinated / population) *100
from PopVsVac 

--Temp table
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(
Continent text,
Location text,
Date date,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);


INSERT INTO PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.date AS date),
    dea.population, 
    CAST(NULLIF(vac.new_vaccinations, '') AS numeric),
    SUM(CAST(NULLIF(vac.new_vaccinations, '') AS numeric))
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
        AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location 
    AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL;
--order by 2,3;
select *, (rollingpeoplevaccinated / population) *100
from  PercentPopulationVaccinated

--Creating View to store data for later visualizations
CREATE OR REPLACE VIEW PercentPopulationVaccinated_View AS
SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.date AS date),
    dea.population, 
    CAST(NULLIF(vac.new_vaccinations, '') AS numeric),
    SUM(CAST(NULLIF(vac.new_vaccinations, '') AS numeric))
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
        AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
    ON dea.location = vac.location 
    AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL;

select *
from PercentPopulationVaccinated_View;



