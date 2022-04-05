-- Show available Databases
SELECT name, database_id, create_date
FROM sys.databases



-- Select database to work with
USE PortfolioProject



-- Show all the columns of the specific table from the selected database
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidDeaths'



-- Show all data from the table & order by 3rd and 4th (ORDINAL_POSITION) column
SELECT * 
FROM CovidDeaths 
ORDER BY 3, 4



-- Show the table data for the specific column
SELECT location, date, population, total_cases, new_cases, total_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date



-- Total Cases VS Total Deaths
-- Shows likelihood of dying in countries starts with United
SELECT location, date, total_cases, total_deaths, ((total_deaths / total_cases) * 100) AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE 'United%'
ORDER BY location, date



-- Total Cases VS Population
-- Shows what percentage of population covid positive in Germany
SELECT location, date, population, total_cases, ((total_cases / population) * 100) AS Covid_Positive_Percentage
FROM CovidDeaths
WHERE location = 'Germany'
ORDER BY date



-- Shows countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS Total_Cases, (MAX(total_cases / population) * 100) AS Percent_Population_Infected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percent_Population_Infected DESC



-- Shows countries with highest death count
SELECT location, MAX(CAST(total_deaths AS INT)) AS Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC



-- BY CONTINENT
-- Shows continent with highest death count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC



-- GLOBALLY
-- Overall death percentage
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, ((SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100) AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL



-- Total Population VS Vaccinations
-- Shows what percentage of population has recieved covid vaccine (PART 1/2)
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS CUMSUM_Vaccinations
FROM CovidDeaths cd JOIN CovidVaccinations cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY location, date



-- Using common table expression (CTE) to perform calculation on partition by in previous query
-- Define the CTE expression name and column list
WITH Population_Vs_Vaccinations (continent, location, date, population, new_vaccinations, CUMSUM_Vaccinations)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS CUMSUM_Vaccinations
FROM CovidDeaths cd JOIN CovidVaccinations cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
-- Define the outer query referencing the CTE name to perform the original query (PART 2/2)
SELECT * , ((CUMSUM_Vaccinations / population) * 100) AS Percent_Population_Vaccinated
FROM Population_Vs_Vaccinations
ORDER BY location, date



-- TEMP TABLE
-- Perform the same query using temp table instead of CTE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
CUMSUM_Vaccinations numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS CUMSUM_Vaccinations
FROM CovidDeaths cd JOIN CovidVaccinations cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY location, date

SELECT * , ((CUMSUM_Vaccinations / population) * 100) AS Percent_Population_Vaccinated
FROM #PercentPopulationVaccinated



-- Create VIEW to store data for later use
DROP VIEW IF EXISTS NumberOfPeopleVaccinated
GO
CREATE VIEW NumberOfPeopleVaccinated AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS CUMSUM_Vaccinations
FROM CovidDeaths cd JOIN CovidVaccinations cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
GO
SELECT * , ((CUMSUM_Vaccinations / population) * 100) AS Percent_Population_Vaccinated
FROM NumberOfPeopleVaccinated
ORDER BY location, date