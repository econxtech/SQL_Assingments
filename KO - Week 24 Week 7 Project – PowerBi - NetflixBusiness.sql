

Use EmadeDev
Select count(*) as nn
From NetflixBusiness

-- 1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS content_count
FROM NetflixBusiness
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows
WITH RatingCounts AS (
    SELECT type, rating, COUNT(*) AS cnt,
           ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM NetflixBusiness
    WHERE rating IS NOT NULL
    GROUP BY type, rating
)
SELECT type, rating, cnt AS most_common_count
FROM RatingCounts
WHERE rn = 1;

-- 3. List all movies released in a specific year 2020
SELECT title, release_year
FROM NetflixBusiness
WHERE type = 'Movie' AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on NetflixBusiness
-- Note: Requires SQL Server 2016+ for STRING_SPLIT
SELECT TOP 5 LTRIM(RTRIM(value)) AS country, COUNT(*) AS content_count
FROM NetflixBusiness
CROSS APPLY STRING_SPLIT(country, ',')
WHERE country IS NOT NULL
GROUP BY LTRIM(RTRIM(value))
ORDER BY content_count DESC;

-- 5. Identify the longest movie
SELECT TOP 1 title, duration
FROM NetflixBusiness
WHERE type = 'Movie' AND duration LIKE '%min%'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INT) DESC;

-- 6. Find content that was added in the last 5 years
SELECT title, date_added
FROM NetflixBusiness
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT title, director, type
FROM NetflixBusiness
WHERE director = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons
SELECT title, duration
FROM NetflixBusiness
WHERE type = 'TV Show' AND duration LIKE '%Seasons%'
  AND CAST(REPLACE(duration, ' Seasons', '') AS INT) > 5;

-- 9. Count the number of content items in each genre
SELECT LTRIM(RTRIM(value)) AS genre, COUNT(*) AS content_count
FROM NetflixBusiness
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE listed_in IS NOT NULL
GROUP BY LTRIM(RTRIM(value))
ORDER BY content_count DESC;

-- 10. Find each year and the number of content releases by India. Return top 5 years with highest releases.
-- Note: "Average" in the prompt typically refers to yearly count in this dataset context.
-- If you strictly need monthly average: CAST(COUNT(*) AS DECIMAL(10,2)) / 12.0
SELECT TOP 5 release_year, COUNT(*) AS total_releases
FROM NetflixBusiness
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY total_releases DESC;

-- 11. List all movies that are documentaries
SELECT title
FROM NetflixBusiness
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT title, type
FROM NetflixBusiness
WHERE director IS NULL OR LTRIM(RTRIM(director)) = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT COUNT(*) AS salman_khan_movie_count
FROM NetflixBusiness
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT TOP 10 LTRIM(RTRIM(value)) AS actor_name, COUNT(*) AS indian_movie_count
FROM NetflixBusiness
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE type = 'Movie'
  AND country LIKE '%India%'
  AND value IS NOT NULL AND LTRIM(RTRIM(value)) <> ''
GROUP BY LTRIM(RTRIM(value))
ORDER BY indian_movie_count DESC;

-- 15: Categorize content based on 'kill' and 'violence' in description. Label as 'Bad', else 'Good'. Count per category.
WITH ContentCategorized AS (
    SELECT 
        CASE 
            WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS content_category
    FROM NetflixBusiness
)
SELECT content_category, COUNT(*) AS item_count
FROM ContentCategorized
GROUP BY content_category;