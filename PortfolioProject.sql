
SELECT * 
FROM PortfolioProject.. CovidDeaths
WHERE continent is NOT NULL
order by 3,4

--SELECT *
--FROM PortfolioProject.. CovidVaccinations

-- Selecting required columns from Covid Death Data
SELECT location, date, total_cases, new_cases,total_deaths,population
FROM PortfolioProject.. CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.. CovidDeaths
ORDER BY 1,2

--Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.. CovidDeaths
where location like '%states'
ORDER BY 1,2

-- Looking at total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject.. CovidDeaths
where location like '%states'
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject.. CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Looking at countries with highest death counts per population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths
WHERE continent is NOT NULL    -- Because where loction was null it had value as the continent
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking things by continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths
WHERE continent is NOT NULL    
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT date, SUM(new_cases) as TotalCases, SUM(cast (new_deaths as int)) as TotalDeaths, SUM(cast (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.. CovidDeaths
WHERE continent is NOT NULL 
GROUP BY date
ORDER BY 1,2


-- Looking at Total population vs Vaccinations
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by deaths.location ORDER BY deaths.location,deaths.date) as RollingPeopleVaccinated
FROM PortfolioProject.. CovidDeaths deaths
JOIN PortfolioProject.. CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is NOT NULL 
ORDER BY 2,3

-- Using CTE
WITH PopvsVacc (continent,location,date,population,new_vaccination,RollingPeopleVaccinated)
as
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by deaths.location ORDER BY deaths.location,deaths.date) as RollingPeopleVaccinated
FROM PortfolioProject.. CovidDeaths deaths
JOIN PortfolioProject.. CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is NOT NULL 
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM PopvsVacc

--TEMP table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by deaths.location ORDER BY deaths.location,deaths.date) as RollingPeopleVaccinated
FROM PortfolioProject.. CovidDeaths deaths
JOIN PortfolioProject.. CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is NOT NULL 
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100 
FROM #PercentPopulationVaccinated

-- Create VIEW to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(CONVERT(bigint,vacc.new_vaccinations)) OVER (Partition by deaths.location ORDER BY deaths.location,deaths.date) as RollingPeopleVaccinated
FROM PortfolioProject.. CovidDeaths deaths
JOIN PortfolioProject.. CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is NOT NULL 
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

-- Collecting Data for Tableau Viz
--Query 1
SELECT SUM(new_cases) as TotalCases, SUM(cast (new_deaths as int)) as TotalDeaths, SUM(cast (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.. CovidDeaths
WHERE continent is NOT NULL 
--GROUP BY date
ORDER BY 1,2	

--Query 2
SELECT location, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject.. CovidDeaths
WHERE continent is NULL    -- Because where loction was null it had value as the continent
AND location not in ('World','European Union','International','Upper middle income','High income','Lower middle income','Low income')
GROUP BY location
ORDER BY TotalDeathCount DESC

--Query 3
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject.. CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Query 4
SELECT location, population,date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject.. CovidDeaths
GROUP BY location, population,date
ORDER BY PercentPopulationInfected DESC

