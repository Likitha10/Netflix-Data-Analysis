-- 1. Count the number of Movies vs TV shows

SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- 3. Identify the top 5 directors with the highest number of releases and the genres they frequently work in.

SELECT 
    director, 
    COUNT(show_id) AS total_shows, 
    STRING_AGG(DISTINCT listed_in, ', ') AS genres
FROM 
    netflix
WHERE 
    director IS NOT NULL
GROUP BY 
    director
ORDER BY 
    total_shows DESC
LIMIT 5;

-- 4. Analyze how the number of TV Shows and Movies has changed over the years.

SELECT 
    release_year, 
    type, 
    COUNT(show_id) AS total_count
FROM 
    netflix
GROUP BY 
    release_year, type
ORDER BY 
    release_year ASC, total_count DESC;

-- 5. Find the top 3 countries with the most content produced and their most frequent genres.

SELECT 
    country, 
    COUNT(show_id) AS total_content, 
    STRING_AGG(DISTINCT listed_in, ', ') AS popular_genres
FROM 
    netflix
WHERE 
    country IS NOT NULL
GROUP BY 
    country
ORDER BY 
    total_content DESC
LIMIT 3;

-- 6. Determine how Netflix content is distributed across different ratings, such as PG, TV-MA, etc.

SELECT 
    rating, 
    COUNT(show_id) AS total_count
FROM 
    netflix
GROUP BY 
    rating
ORDER BY 
    total_count DESC;

-- 7. Identify the month with the highest number of content added to Netflix.

SELECT 
    TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'MM') AS month_number,
    TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS month_name,
    COUNT(show_id) AS total_content
FROM 
    netflix
WHERE 
    date_added IS NOT NULL
GROUP BY 
    month_number, month_name
ORDER BY 
    month_number ASC;

-- 8. Identify the most popular genre each year based on the number of shows/movies released.

SELECT 
    release_year, 
    listed_in AS genre, 
    COUNT(show_id) AS total_count
FROM 
    netflix
GROUP BY 
    release_year, genre
ORDER BY 
    release_year ASC, total_count DESC;

-- 9. Identify the most frequent cast pairs that appear together in Netflix content.

WITH cast_pairs AS (
    SELECT 
        show_id, 
        UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor
    FROM 
        netflix
)
SELECT 
    p1.actor AS actor_1, 
    p2.actor AS actor_2, 
    COUNT(*) AS collaboration_count
FROM 
    cast_pairs p1
JOIN 
    cast_pairs p2
ON 
    p1.show_id = p2.show_id AND p1.actor < p2.actor
GROUP BY 
    p1.actor, p2.actor
ORDER BY 
    collaboration_count DESC
LIMIT 5;

-- 10.  Determine how much content is produced outside the India each year and its percentage of the total.

SELECT 
    release_year, 
    COUNT(CASE WHEN country != 'India' THEN 1 END) AS international_content, 
    COUNT(show_id) AS total_content,
    ROUND(100.0 * COUNT(CASE WHEN country != 'India' THEN 1 END) / COUNT(show_id), 2) AS percentage_international
FROM 
    netflix
GROUP BY 
    release_year
ORDER BY 
    release_year ASC;

-- 11. Calculate the average duration of movies by genre.

SELECT 
    listed_in AS genre, 
    ROUND(AVG(CAST(REGEXP_REPLACE(duration, ' min', '') AS INT)), 2) AS avg_duration_minutes
FROM 
    netflix
WHERE 
    type = 'Movie' AND duration LIKE '%min%'
GROUP BY 
    genre
ORDER BY 
    avg_duration_minutes DESC;

-- 12. Find the country with the most diverse genres represented in its Netflix content.

SELECT 
    country, 
    COUNT(DISTINCT listed_in) AS genre_count
FROM 
    netflix
WHERE 
    country IS NOT NULL
GROUP BY 
    country
ORDER BY 
    genre_count DESC
LIMIT 1;



