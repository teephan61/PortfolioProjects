Select *
From PortfolioProject..CovidDeaths
Where Continent is NOT NUll
Order by 3,4

--Select *
--From PortfolioProject.Select Location, Date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--order by 1,2.CovidVaccinations
--order by 3,4



--Total Cases vs Total Deaths

Select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like 'Canada'
and Continent is NOT NULL
Order by 1,2

--Total Cases vs Population

Select Location, Date, Total_cases, Population, (Total_cases/Population)*100 as CasesPercentage
From PortfolioProject..CovidDeaths
where Location like 'Canada'
and Continent is NOT NULL
Order by 1,2

--Countires with Highest Infection Rate compared to Population

Select Location Population, MAX(Total_cases) as HighestInfectionCount,  MAX((Total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected DESC

--Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is NOT NUll
Group by Location, Population
Order by TotalDeathCount DESC

--Continents with Highest Death Count

Select Continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is NOT NUll
Group by Continent
Order by TotalDeathCount DESC

--Global Numbers

Select Date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is NOT NULL
Group by Date
Order by 1,2

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is NOT NULL
Order by 1,2



--Total Population vs Vaccinations


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as VaccinatedPercentage
From PopvsVac

--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select *
From PercentPopulationVaccinated