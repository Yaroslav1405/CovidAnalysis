# COVID-19 Global Data Dashboard

## Introduction
This dashboard visualizes global COVID-19 data, including infection rates, death rates, vaccination progress, and geographical distribution of cases. It provides insights into the pandemic's progression from 2020 to 2024.

## Features
* Global summary of cases, deaths, and vaccination rates.
* Comparison of deaths by continents and countries.
* Visualization of yearly infection trends and geographical impact.
* Vaccination analysis (vaccinated vs. non-vaccinated populations).
* Trend analysis using log scale for cases and deaths over time.

## Technologies Used
* **Queries and Views:** PostgreSQL.
* **Data Visualization:** Power BI.
* **Data Source:** [Covid Data](https://ourworldindata.org/explorers/covid)

## How to Use Dashboard:
1. Summary Cards: Overview of Key Statistics
* Position: Located at the top of the dashboard.
* Metrics Displayed:
  * Sum of Total Cases (776M): Total number of confirmed COVID-19 cases globally.
  * Sum of Total Deaths (7M): Total deaths reported globally.
  * Average Death per Case (2.05%): Percentage of COVID-19 cases that resulted in death.
* How to Use:
  * These cards provide a quick snapshot of the most critical statistics to give users an immediate sense of the global scale of the pandemic.
2. Infected First vs. Last Year (Bar Chart)
* Position: Top center.
* Metric Displayed: Comparison of the total number of infections in 2020 vs. 2024.
* How to Use:
  * This simple bar chart compares the infection rate in the first year of the pandemic (80.32M in 2020) with the current year (2.06M in 2024).
  * Hover over each bar to see the exact number of infected people in each year.
  * Key Insight: A dramatic decrease in infections from 2020 to 2024 shows the impact of global efforts, including vaccinations, lockdowns, and other measures.
3. Bar Chart: Total Deaths by Continent
* Position: Center left.
* Metric Displayed: Number of deaths per continent (Europe, North America, Asia, etc.).
* How to Use:
  * Bars represent the total number of deaths in each continent. The higher the bar, the more deaths occurred.
  * Hover over each bar to view the exact number of deaths.
  * Key Insights: Europe has the highest number of deaths (2.1M), followed by North America (1.67M).
4. Pie Chart: Vaccinated vs. Not Vaccinated
* Position: Center of the dashboard.
* Metric Displayed: Breakdown of the global population into vaccinated and not vaccinated.
  * Vaccinated (Lime Green): Represents the portion of the population that has been vaccinated at least once.
  * Not Vaccinated (Gray): Represents the portion of the population that has not been vaccinated.
* How to Use:
  * The chart is divided into two main slices—vaccinated (29.33%) and not vaccinated (70.67%).
  * Hover over each slice to see the precise percentage and population size.
  * Key Insight: A large portion of the global population remains unvaccinated, highlighting the challenges that still need to be addressed in vaccine distribution.
5. Map: Infected Percentage of Population
* Position: Top-right.
* Metric Displayed: Visual representation of the percentage of each country's population that has been infected.
* How to Use:
  * The color scale represents the percentage of population infected by country. Darker shades indicate a higher percentage of the population infected.
  * Users can hover over any country to view the exact percentage.
  * Key Insight: Countries with higher infection rates (e.g., parts of Europe and the Americas) are more visibly shaded.
6. Bar Chart: Total Deaths by Country
* Position: Bottom-left.
* Metric Displayed: Number of deaths for specific countries.
* How to Use:
  * Each bar represents a country, showing the total deaths from COVID-19.
  * Hovering over a bar will show the exact number of deaths for that country.
  * Key Insight: The United States has the highest number of deaths at 1.19M, followed by Brazil and India.
7. Gauge Chart: Fully Vaccinated Population
* Position: Bottom-left.
* Metric Displayed: Number of people globally who have been fully vaccinated.
* How to Use:
  * The gauge represents the global vaccination progress, with a marker showing the number of fully vaccinated people compared to the total vaccinated.
  * Key Insight: With 5.23 billion people vaccinated, the global effort has made significant strides but there is still a way to go.
8. Pie Chart: Total Deaths Distribution by Continent
* Position: Bottom center.
* Metric Displayed: The proportion of total deaths distributed across continents.
* How to Use:
  * This chart is divided into several segments, each representing a continent’s share of the global death toll.
  * Hover over each segment to view the continent's name and its corresponding death toll as a percentage of the global total.
  * Key Insight: Europe and North America account for nearly 50% of the global death toll, reflecting their substantial impact.
9. Line Chart: Total Cases and Deaths by Year (Log Scale)
* Position: Bottom right.
* Metric Displayed: A timeline showing the total number of COVID-19 cases and deaths from 2020 to 2024 on a logarithmic scale.
* How to Use:
  * The blue line represents total cases, while the red line represents total deaths. Both are plotted over time from 2020 to 2024.
  * Hover over any point on the lines to see the exact number of cases or deaths at a specific time.
  * Key Insight: The chart shows that after a rapid rise in cases and deaths in the early years (2020-2022), both have started to plateau and decline in 2023 and 2024.
