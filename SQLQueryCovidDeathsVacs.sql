Select *
From CovidProject1..CovidVaccinations 
order by 3,4

Select *
From CovidProject1..CovidDeaths
Where continent is not null
order by 3,4

--Select data that we are going to be using

Select Location, date, total_cases_per_million, total_deaths, population 
From CovidProject1..CovidDeaths
order by 1,2 

--Looking at Total deaths vs Population
--Shows what percentage of population got Covid

Select Location, date, population, total_deaths, (total_deaths/population)*100 as DeathPercentage
From CovidProject1..CovidDeaths
--Where location like '%......%'
order by 1,2

--What countries have the highest death rate per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject1..CovidDeaths
--Where location like '%......%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


--What continent had the highest death counts

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject1..CovidDeaths
--Where location like '%......%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS


--total deaths and total cases

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From CovidProject1..CovidDeaths
where continent is not null 
order by 1,2 

-- Both tables joined

Select *
From CovidProject1..CovidDeaths 
Join CovidProject1..CovidVaccinations vac
    ON dea.location = vac.location 
    and dea.date = vac.date 


--Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From CovidProject1..CovidDeaths dea
Join CovidProject1..CovidVaccinations vac
    On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Looking at total population vs Vaccinations with rolling count
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject1..CovidDeaths dea
Join CovidProject1..CovidVaccinations vac
    On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
order by 2,3

--TEMP TABLE 

Drop Table if exists NoPercentPopVac 
Create table NoPercentPopVac 
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population numeric,
    New_vaccinations numeric, 
    RollingPeopleVaccinated numeric
)

Insert into NoPercentPopVac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject1..CovidDeaths dea
Join CovidProject1..CovidVaccinations vac
    On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *,(RollingPeopleVaccinated/population)*100
From NoPercentPopVac


--Creating View to store data for later visualisation

Create view PercentPopVac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject1..CovidDeaths dea
Join CovidProject1..CovidVaccinations vac
    On dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
