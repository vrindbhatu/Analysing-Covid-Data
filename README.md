### Dataset
-> I acquired the dataset from https://ourworldindata.org/coronavirus which contains data from Jan 28th, 2020 untill today. For this project I have data from Jan 2020 till Jun 6th, 2022. 

-> I further divided the entire dataset into two different dataset CovidDeaths and CovidVaccinations by selecting only certain columns.

-> CovidDeaths contained features that had information about the newtotal deaths cases, whereas CovidVaccination contained features regarding vaccination given to the total population.

### Loading Data to MS SQL Server
-> I created a new database "PortfolioProject" and loaded the two excel files into it by using SQL Server Import Export Data.

### Executing SQL Queries
-> Finally for getting insights out of data I performed certain queries.

-> Got information about the following things:

1. Looking at Total Cases vs Total Deaths for each country.
2. Finding the likelihood of dying if someone gets covid in a particular country.
3. Looking at the total cases vs the population (Highest infection rate)and from that finding the percent of population that got covid.
4. Looking at countries that has highest death counts.

-> Along with this I also created CTE (Common Table Experession) to enable users to more easily write and maintain complex queries via increased readability and simplification, a TEMP table and VIEW which can store data for later viszualizations. 

### Exporting data from SQL Server and loading into Tableau

-> After getting a better understanding on the data I tried to create a dashboard on Tableau. Link to Tableau public https://public.tableau.com/app/profile/vrinda1964/viz/ProjectPortfolio_16553371717070/Dashboard1

-> On hovering over the map one can get the perfecting pf population infected for the respective country.

-> The bar chart which is sorted in the desecnding order based on the death count of the countinents can be used by nations to help countries in tyhe countinent having highest death count and try to bring it under control.

-> The last graph that is line graph I have tried to see the trend in the covid cased of United States which can be compared with the selected country. And based on that also tried to forcast this trend in near future.

