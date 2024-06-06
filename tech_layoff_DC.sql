# Data cleaning:Tech-layoffs from kaggle.com

SELECT * FROM layoffs;

# to create a new table from original layoffs dataset for DC purpose
CREATE TABLE layoffs_stagging LIKE layoffs;

# to see newly created database
SELECT * FROM layoffs_stagging;

# to insert all data into newly created layoffs_staging table
INSERT layoffs_stagging
SELECT * FROM layoffs;

# to see newly create layoffs_stagging
SELECT * FROM layoffs_stagging;

# to insert a new col: 'row_num' using PARTITION BY table columns
# to check for any duplicated in the dataset
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_stagging;

# to create a CTE table to check for duplicates, there are 36 duplicated values
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_stagging
)
SELECT * FROM duplicate_CTE
WHERE row_num > 1;

# to double-check for duplicated values, can see that 'country' is different
SELECT * FROM layoffs_stagging
WHERE company = 'Oda';

# to PARTITION BY all columns to check for duplicated values again
# there are 22 rows of duplicated avlues
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
)
SELECT * FROM duplicate_CTE
WHERE row_num > 1;

SELECT * FROM layoffs_stagging
WHERE company = 'Casper';

# to create a new table layoffs_stagging2 and delete duplicated values from it
CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`  int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# to see newly created table layoff_stagging2
SELECT * FROM layoffs_stagging2;

# to insert original data into new table layoffs_stagging2
INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

# to see new table
SELECT * FROM layoffs_stagging2;

# to see all duplicated values, 22 rows of duplicated values
SELECT * FROM layoffs_stagging2
WHERE row_num > 1;


# to delete all duplicated values
DELETE FROM layoffs_stagging2
WHERE row_num > 1;

# all duplicated rows have been deleted
SELECT * FROM layoffs_stagging2
WHERE row_num > 1;

# standardizing data
SELECT DISTINCT(company) FROM layoffs_stagging2;

# to remove white spaces from 'company'
SELECT company, TRIM(company) FROM layoffs_stagging2;

# to permanently remove white spaces in table using UPDATE
UPDATE layoffs_stagging2 
SET company = TRIM(company);

# double-check that white spaces have been removed
SELECT company, TRIM(company) FROM layoffs_stagging2;

# there are 34 different industries
SELECT DISTINCT industry FROM layoffs_stagging2
ORDER BY 1;

# 'Crypto' is not standardised
SELECT * FROM layoffs_stagging2 
WHERE industry LIKE 'Crypto%';

# to standardise where industry = 'Crypto', 3 rows changed
UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# after standardising, there are 32 different industries
SELECT DISTINCT industry FROM layoffs_stagging2;

# there are 191 locations
SELECT DISTINCT location FROM layoffs_stagging2
ORDER BY 1;

# there are 60 countries
SELECT DISTINCT country FROM layoffs_stagging2;

# there are 2 different versions of states, the other version has a full stop.
SELECT DISTINCT country FROM layoffs_stagging2
WHERE country LIKE '%states%';

# trailing removes the '.' at the end of States
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM layoffs_stagging2;

# to permanently remove the '.' from States using UPDATE statement
UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States';

# to see the changes after removing '.'
SELECT DISTINCT country FROM layoffs_stagging2;

# to change the date column to date format, currently its a text format
SELECT date FROM layoffs_stagging2;

# using STR_TO_Date function to change column into Date format
SELECT date, str_to_date(date, '%m/%d/%Y') FROM layoffs_stagging2;

# to make permanently changes to actual table
UPDATE layoffs_stagging2
SET date = str_to_date(date, '%m/%d/%Y');

# to double check date column has been changed to date format
SELECT date FROM layoffs_stagging2;

# to completely change the layoff_stagging2 table, to a DATE format
ALTER TABLE layoffs_stagging2
MODIFY COLUMN date DATE;

-- Refresh the schemas to see the change of date to DATE format

-- Dealing with missing values

-- there are 348 missing rows
SELECT * FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_stagging2
WHERE industry IS NULL or industry = '';

SELECT * FROM layoffs_stagging2
WHERE company LIKE '%Airbnb%';

-- to delete columns not useful for analysis
DELETE FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- double check that missing rows are deleted
SELECT * FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_stagging2;

# to permanently remove row_num column
ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

# to check the final dataset
SELECT * FROM layoffs_stagging2;


























