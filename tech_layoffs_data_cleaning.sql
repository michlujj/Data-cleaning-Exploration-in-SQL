---Website: layoff.csv from kaggle.com
-- change to Portfolio project before running SQL queries


---Exploratory data analysis in SQL
SELECT * FROM [Portfolio project]..layoffs;

--- to create a new table (w /no data): layoffs_stagging from original 'layoffs', then click 'Refresh' Portfolio project
SELECT TOP 0 *
INTO layoffs_staging
FROM [Portfolio project]..layoffs;

-- to check the newly created layoffs_staging table
SELECT * FROM [Portfolio project]..layoffs_staging;

-- to import all the data from the original table 'layoffs'
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- to double check that data has been added into new table: layoffs_staging
SELECT * FROM [Portfolio project]..layoffs_staging;

--- to identify presence of any duplicated rows from layoffs_staging table, using row_num to check for duplicates
-- to PARTITION BY OVER () all columns (spell out every column), there are 7 duplicated values
WITH duplicated_CTE AS(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY
	company, industry, total_laid_off, percentage_laid_off,date
	ORDER BY company) row_num
FROM [Portfolio project]..layoffs_staging
)
SELECT * FROM duplicated_CTE
WHERE row_num > 1
ORDER BY company;

-- there are 3 'Oda' company in dataset
SELECT * FROM [Portfolio project]..layoffs_staging
WHERE company = 'Oda';

-- to use row_num to check for duplicates
-- this time to PARTITION BY OVER () all columns (spell out every column)
-- as it turns out there are 5 rows of duplicated data
WITH duplicated_CTE AS(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY
	company, industry, location, total_laid_off, percentage_laid_off,date,stage,country, funds_raised_millions
	ORDER BY company) row_num
FROM [Portfolio project]..layoffs_staging
)
SELECT * FROM duplicated_CTE
WHERE row_num > 1
ORDER BY company;

-- to see all rows for company = 'Casper' (3 duplicated rows)
SELECT * FROM [Portfolio project]..layoffs_staging
WHERE company = 'Casper';


-- to delete all 5 duplicated rows
WITH duplicated_CTE AS(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY
	company, industry, location, total_laid_off, percentage_laid_off,date,stage,country, funds_raised_millions
	ORDER BY company) row_num
FROM [Portfolio project]..layoffs_staging
)
Delete
FROM duplicated_CTE 
WHERE row_num > 1


-- to double-check that all duplicated rows have been removed
WITH Row_CTE AS(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY
	company, industry, location, total_laid_off, percentage_laid_off,date,stage,country, funds_raised_millions
	ORDER BY company) row_num
FROM [Portfolio project]..layoffs_staging
)
SELECT * FROM Row_CTE
WHERE row_num > 1
ORDER BY company;

SELECT * FROM [Portfolio project]..layoffs_staging

-- to standardise dataset

-- to see names of all companies in the dataset
-- there are 
SELECT DISTINCT(company)
FROM [Portfolio project]..layoffs_staging;

--there are 1885 unique company in the dataset, TRIM removes the white space at the end
SELECT company, TRIM(company)
FROM [Portfolio project]..layoffs_staging;

--to alter the table permanently by gettting rid of whitespaces in 'company' using Update
UPDATE layoffs_staging
SET company = TRIM(company);

-- to see that TRIM has taken place
SELECT company, TRIM(company)
FROM [Portfolio project]..layoffs_staging;

-- 'Crypto','Crypto Currency', 'CryptoCurrency' are synomyns of the same item
-- there are missing values
SELECT DISTINCT industry FROM [Portfolio project]..layoffs_staging
ORDER BY 1;

--to select everything when industry LIKE 'Crypto' using wild card % at the end
-- there are 102 rows with Industry similar to 'Crypto'
SELECT * FROM [Portfolio project]..layoffs_staging
WHERE industry LIKE 'Crypto%';

-- to standardise industry to using UPDATE and SET function (permanent)
UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- to see the change in 'industry' where it has taken place
SELECT * FROM [Portfolio project]..layoffs_staging
WHERE industry LIKE 'Crypto%';

-- after editing, there are 32 industries in total
SELECT DISTINCT(industry)
FROM [Portfolio project]..layoffs_staging;

-- there are 191 locations
SELECT DISTINCT(location)
FROM [Portfolio project]..layoffs_staging
ORDER BY 1;

-- there are United States. and United States as different countries due to the '.'
SELECT DISTINCT country
FROM [Portfolio project]..layoffs_staging;

-- to see the error in country
SELECT DISTINCT country, TRIM(country)
FROM [Portfolio project]..layoffs_staging
ORDER BY 1;

-- use trailing to remove '.', at the end, to specify that it is not a white space from 'United States.'
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM [Portfolio project]..layoffs_staging
ORDER BY 1;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- to see that '.' has been removed for 'United States in the (no column name)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM [Portfolio project]..layoffs_staging
ORDER BY 1;

-- to remove unimport columns

SELECT *
FROM [Portfolio project]..layoffs_staging;
WHERE total_laid_off IS NULL;

SELECT *
FROM [Portfolio project]..layoffs_staging;
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- to Delete away unimportant column data we can't really use
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM [Portfolio project]..layoffs_staging;
