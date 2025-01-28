# 📊 Netflix Dataset SQL Analysis

## 📌 Introduction
This project explores the Netflix dataset available on [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download) using **advanced SQL queries**. The analysis provides valuable business insights into content distribution, trends, and patterns on Netflix.

The project is structured to demonstrate **data exploration, transformations, and analytical skills** with SQL. The queries cover **aggregations, window functions, string manipulations, and common table expressions (CTEs)** to extract meaningful insights.

---

## 📂 Dataset Overview
The dataset consists of Netflix TV Shows and Movies with the following attributes:

| Column Name   | Description |
|--------------|-------------|
| `show_id`     | Unique identifier for each show |
| `type`        | Type of content: Movie or TV Show |
| `title`       | Title of the show |
| `director`    | Director(s) of the content |
| `cast`       | Lead actors in the show |
| `country`     | Country where the show was produced |
| `date_added`  | Date when the show was added to Netflix |
| `release_year` | Year the show was released |
| `rating`      | Content rating (e.g., PG, TV-MA) |
| `duration`    | Duration of the movie or number of seasons for TV shows |
| `listed_in`   | Genre(s) associated with the content |
| `description` | Brief description of the show |

---

## 🔍 Business Questions Solved with SQL
Below are the key insights extracted from the dataset:

1️⃣ **Count the number of Movies vs. TV Shows**  
2️⃣ **Find the most common rating for Movies and TV Shows**  
3️⃣ **Identify the top 5 directors with the highest number of releases and their popular genres**  
4️⃣ **Analyze how the number of TV Shows and Movies has changed over the years**  
5️⃣ **Find the top 3 countries with the most content produced and their most frequent genres**  
6️⃣ **Determine how Netflix content is distributed across different ratings (PG, TV-MA, etc.)**  
7️⃣ **Identify the month with the highest number of content added to Netflix**  
8️⃣ **Find the most popular genre each year based on the number of releases**  
9️⃣ **Identify the most frequent cast pairs that appear together in Netflix content**  
🔟 **Analyze how much content is produced outside India each year and its share in the total Netflix content**  
1️⃣1️⃣ **Calculate the average duration of movies by genre**  
1️⃣2️⃣ **Find the country with the most diverse genres represented in its Netflix content**  

---

## 🛠 SQL Queries

### **1️⃣ Count the number of Movies vs. TV Shows**
```sql
SELECT
    type,
    COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

### **2️⃣ Find the most common rating for Movies and TV Shows**
```sql
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
```

### **3️⃣ Identify the top 5 directors with the highest number of releases and their popular genres**
```sql
SELECT
    director,
    COUNT(show_id) AS total_shows,
    STRING_AGG(DISTINCT listed_in, ', ') AS genres
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_shows DESC
LIMIT 5;
```

### **4️⃣ Analyze how the number of TV Shows and Movies has changed over the years**
```sql
SELECT
    release_year,
    type,
    COUNT(show_id) AS total_count
FROM netflix
GROUP BY release_year, type
ORDER BY release_year ASC, total_count DESC;
```

### **5️⃣ Find the top 3 countries with the most content produced and their most frequent genres**
```sql
SELECT
    country,
    COUNT(show_id) AS total_content,
    STRING_AGG(DISTINCT listed_in, ', ') AS popular_genres
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 3;
```

### **6️⃣ Determine how Netflix content is distributed across different ratings**
```sql
SELECT
    rating,
    COUNT(show_id) AS total_count
FROM netflix
GROUP BY rating
ORDER BY total_count DESC;
```

### **7️⃣ Identify the month with the highest number of content added to Netflix**
```sql
SELECT
    TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'MM') AS month_number,
    TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS month_name,
    COUNT(show_id) AS total_content
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY month_number, month_name
ORDER BY month_number ASC;
```

### **8️⃣ Find the most popular genre each year**
```sql
SELECT
    release_year,
    listed_in AS genre,
    COUNT(show_id) AS total_count
FROM netflix
GROUP BY release_year, genre
ORDER BY release_year ASC, total_count DESC;
```

### **9️⃣ Identify the most frequent cast pairs that appear together**
```sql
WITH cast_pairs AS (
    SELECT
        show_id,
        UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor
    FROM netflix
)
SELECT
    p1.actor AS actor_1,
    p2.actor AS actor_2,
    COUNT(*) AS collaboration_count
FROM cast_pairs p1
JOIN cast_pairs p2
ON p1.show_id = p2.show_id AND p1.actor < p2.actor
GROUP BY p1.actor, p2.actor
ORDER BY collaboration_count DESC
LIMIT 5;
```

---

## 📌 How to Use
1. Clone the repository or copy the SQL queries.
2. Load the Netflix dataset into **PostgreSQL/MySQL/SQLite**.
3. Execute the queries in an SQL environment.
4. Analyze and interpret the insights.

---

## 📢 Connect with Me
If you have any questions or feedback, feel free to connect with me!

