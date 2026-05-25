# Covid-19 Data Exploration — SQL Project

## Overview
This project explores global Covid-19 data using SQL to analyse infection rates, death counts, and vaccination rollouts across countries and continents.

**Dataset:** Our World in Data — Covid Deaths & Vaccinations (2020–2021)
**Tools:** PostgreSQL
**Skills demonstrated:** Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Type Casting, CASE statements, Views

---

## Business Questions Explored

1. What was the likelihood of dying if you contracted Covid in the United States?
2. What percentage of the US population was infected over time?
3. Which countries had the highest infection rates relative to their population?
4. Which countries and continents had the highest total death counts?
5. What were the global daily death percentages over time?
6. How did vaccination rollout progress relative to population size across all countries?

---

## Key Findings

- **US death-to-case ratio** was calculated daily using a CASE statement to avoid division-by-zero errors, revealing how mortality risk changed over the course of the pandemic.
- **North America had the highest total death count** among all continents, followed by South America and Asia.
- **Rolling vaccination progress** was tracked per country using a window function (SUM OVER PARTITION), showing the cumulative share of each population vaccinated over time.
- **Global daily death percentage** was derived by aggregating new cases and new deaths worldwide, showing how the global fatality rate evolved month by month.

---

## Project Structure

```sql
-- 1. Initial data exploration (coviddeaths, covidvaccinations)
-- 2. Total cases vs total deaths — US death percentage over time
-- 3. Total cases vs population — US infection rate over time
-- 4. Countries with highest infection rate vs population
-- 5. Countries with highest total death count
-- 6. Continents with highest total death count
-- 7. Global numbers — daily case and death totals worldwide
-- 8. Population vs vaccinations — rolling count using CTE
-- 9. Temp table — PercentPopulationVaccinated
-- 10. View — created for Tableau visualization
```

---

## Advanced SQL Techniques Used

| Technique | Where Used |
|---|---|
| CASE statement | Death percentage (avoid divide by zero) |
| Type casting | total_deaths, new_deaths, new_vaccinations |
| NULLIF | Handling empty strings in vaccination data |
| CTE (WITH clause) | Rolling vaccination count per country |
| Temp table | Storing vaccination progress for reuse |
| Window function (SUM OVER) | Cumulative vaccinations partitioned by location |
| JOIN | Linking coviddeaths and covidvaccinations tables |
| CREATE VIEW | Storing final query for Tableau dashboard |

---

## How to Use

1. Download the Covid Deaths and Covid Vaccinations datasets from [Our World in Data](https://ourworldindata.org/covid-deaths)
2. Import both tables into PostgreSQL
3. Run queries in order from the script file

---

## Connect
[Tableau Dashboard](https://public.tableau.com/app/profile/ruhizar.eminbayli/viz/Tableauproject_17641836097500/Dashboard1) | https://www.linkedin.com/in/ruhizar-eminbayli-4466363a5?utm_source=share_via&utm_content=profile&utm_medium=member_ios
