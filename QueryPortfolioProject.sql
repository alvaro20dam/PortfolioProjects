SELECT *
FROM PortfolioProject..CovidDeaths
order by 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1, 2

--Comparamos total_cases vs total_deaths

SELECT Location, date, total_cases, total_deaths, 
	(CONVERT(FLOAT, total_deaths)/CONVERT(FLOAT, total_cases))*100
	AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Venezuela%'
order by 1, 2

--CAST(total_cases as INT)
-- porcentaje de infectados vs poblacion

SELECT Location, date, total_cases, population, 
	(CONVERT(FLOAT, total_cases)/CONVERT(FLOAT, population))*100
	AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Venezuela%'
order by 1, 2

--Comparando paises con la mayor tasa de infeccion
SELECT Location, population, MAX(CONVERT(FLOAT, total_cases)) AS HighestInfectedCount,
	MAX((CONVERT(FLOAT, total_cases))/CONVERT(FLOAT, population))*100 AS InfectedPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
order by InfectedPercentage DESC

-- mostrando paises con mayor tasa de muertes

SELECT Location, MAX(CONVERT(FLOAT, total_deaths)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
order by TotalDeathCount DESC

--Ahora continentes
SELECT continent, MAX(CONVERT(FLOAT, total_deaths)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by TotalDeathCount DESC

-- global numbers
SELECT SUM(CONVERT(FLOAT, new_cases)) as total_cases, SUM(CONVERT(FLOAT, new_deaths)) as 
	total_deaths, SUM(CONVERT(FLOAT, new_deaths))/SUM(CONVERT(FLOAT, new_cases))*100 as
	DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

WITH PopvsVac (Continent, location, Date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)









