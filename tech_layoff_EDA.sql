-- Exploratory Data analysis

SELECT * FROM layoffs_stagging2;

-- to see the maximum no. of employees who got retrenched
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_stagging2;

-- to see companies (115) who retrenched 100% of the employees
SELECT * FROM layoffs_stagging2
WHERE percentage_laid_off = 1;

-- to arrange total no. retrenched in descending order 
SELECT * FROM layoffs_stagging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC;

-- dataset contains 3 years of retrenchment data
SELECT MIN(date), MAX(date) FROM layoffs_stagging2;

-- to see which industry got deeply affected the most
SELECT industry, SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY industry
ORDER BY 2 DESC;

-- to see which countries that are most affected by tech layoffs
SELECT country, SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY country
ORDER BY 2 DESC;

-- to see total laid off by Date
SELECT date, SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY date
ORDER BY 2 DESC;

-- to see total laid off by Year
SELECT YEAR(date), SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT company, SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC;

-- to view the cumulative frequency lay offs by month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_stagging2
GROUP BY dates
ORDER BY dates DESC;

# using CTE to view the cumulative frequency, OVER order by dates
WITH cumulative_freq AS
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_stagging2
GROUP BY dates
ORDER BY 1
)
SELECT dates, total_laid_off, SUM(total_laid_off) OVER(ORDER BY dates) AS cumulative_total_layoffs
FROM cumulative_freq
ORDER BY dates;

-- to view layoff by company, year and total lay offs
SELECT company, YEAR(date), SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company, YEAR(date)
ORDER BY company;

-- to rank by total no. of employees(3) laid off
-- Google fired 12000 employees in 2023, Meta fired 11000 employees in 2022
SELECT company, YEAR(date), SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

-- using CTE to look at Companies with the most layoffs by year, by Rankings.
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date), SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company, YEAR(date)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking;

-- to rank by total no. of employees(3) laid off by Company and Year, Ascending order
-- to see Top 5 company that fired the most employees by Year
-- Dense Rank(): a window function that assigns a rank to each row within a partition
-- rank of a row increased by one from the no. of distinct rank values before the row
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date), SUM(total_laid_off) FROM layoffs_stagging2
GROUP BY company, YEAR(date)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE Ranking <= 5;




