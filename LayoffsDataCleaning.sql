-- Data CLeaning

SELECT * FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null Values or Blank values
-- 4. Remove any columns( instead of deleteing the columns from the raw table, we create a layoffs_staging table)


CREATE TABLE layoffs_staging
LIKE layoffs;
 
SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

-- 1. REMOVE DUPLICATES

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country,
funds_raised_millions)
AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num>1;

-- CHecking the duplicate rows data.
SELECT *
FROM layoffs_staging
WHERE company='Casper';
SELECT *
FROM layoffs_staging
WHERE company='Cazoo';
SELECT *
FROM layoffs_staging
WHERE company='Wildlife Studios';

-- deleteing duplicate rows
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country,
funds_raised_millions)
AS row_num
FROM layoffs_staging
)
DELETE   -- Unable to use DELETE to delete the rows from the cte table.  
FROM duplicate_cte
WHERE row_num>1;

-- To actually delete the duplicate data, we have to create a table that contains the row_num column, and then delete the duplicate data.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- Inserting data into layoffs_staging2 table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country,
funds_raised_millions)
AS row_num
FROM layoffs_staging;

-- Deleting the duplicate rows with row_num>1
DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;

-- 2. STANDARDIZING DATA (finding issues in the data and fixing it)
SELECT * 
FROM layoffs_staging2;

SELECT company, TRIM(company)    
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company); -- Removing extra spaces from company name

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;   -- CRypto crypto currency industries are same, we need to merge it in one.

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Updating all records to be just "Crypto"
UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

-- Looking at locations
SELECT DISTINCT location
FROM layoffs_staging2 
ORDER BY 1;   -- FINE
-- Looking at country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;   -- THEre are two names United States and United States.

SELECT DISTINCT country, TRIM( TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country= TRIM( TRAILING '.' FROM country)
WHERE country LIKE 'United States%';  -- DONE

-- DATE column (in the data, the data type for date is text, it should be of date type)
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');
SELECT `date`
FROM layoffs_staging2;  -- the data type is still text, but in the correct date format

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;   -- updated the data type of 'date' column to date instead of text

SELECT * 
FROM layoffs_staging2;

-- 3. NULL VALUES/BLANK VALUES
-- dealing with total_laid_off column
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;  -- if both are null, the record is useless

UPDATE layoffs_staging2
SET  industry= NULL
WHERE industry='';  -- this query is written so that the next query for filling the industry type could run,
-- it was not running because of blanks and null confusion.

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';

-- let's look at these companies with null industries, and try to find other records of these industries so that we can try to fill in the null values
SELECT * 
FROM layoffs_staging2
WHERE company='Airbnb';   -- we now know that airbnb's industry is Travel

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
SET t1.industry= t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- deleting data where total laid off and percent is null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;






