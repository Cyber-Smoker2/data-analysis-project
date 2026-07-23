-- FIFA Player Data Analysis
-- Dataset: Kaggle FIFA players CSV, ~17,900 rows

-- Query 1: Sanity check — total players
SELECT COUNT(*) AS total_players FROM players;

-- Query 2: Average rating by nationality (min 20 players)
SELECT nationality, ROUND(AVG(overall_rating), 1) AS avg_rating, COUNT(*) AS player_count
FROM players
GROUP BY nationality
HAVING player_count >= 20
ORDER BY avg_rating DESC
LIMIT 15;

-- Query 3: Top nationalities by count of elite players (85+)
SELECT nationality, COUNT(*) AS elite_players
FROM players
WHERE overall_rating >= 85
GROUP BY nationality
ORDER BY elite_players DESC
LIMIT 10;

-- Query 4: Value vs wage mismatch (window functions + CTE)
-- Note: value_euro/wage_euro stored as TEXT in source data — cast to REAL
-- to avoid incorrect lexicographic sorting (bug found during analysis)
WITH ranked AS (
  SELECT name, nationality,
         CAST(value_euro AS REAL) AS value_euro,
         CAST(wage_euro AS REAL) AS wage_euro,
         RANK() OVER (ORDER BY CAST(value_euro AS REAL) DESC) AS value_rank,
         RANK() OVER (ORDER BY CAST(wage_euro AS REAL) DESC) AS wage_rank
  FROM players
  WHERE CAST(value_euro AS REAL) > 1000000 AND CAST(wage_euro AS REAL) > 5000
)
SELECT *, (wage_rank - value_rank) AS underpaid_gap
FROM ranked
ORDER BY underpaid_gap DESC
LIMIT 15;

-- Query 5: Age vs rating curve
-- Note: age and overall_rating also stored as TEXT — cast required
SELECT
  CASE
    WHEN CAST(age AS INTEGER) < 21 THEN 'Under 21'
    WHEN CAST(age AS INTEGER) BETWEEN 21 AND 25 THEN '21-25'
    WHEN CAST(age AS INTEGER) BETWEEN 26 AND 30 THEN '26-30'
    ELSE '31+'
  END AS age_group,
  ROUND(AVG(CAST(overall_rating AS REAL)), 1) AS avg_rating,
  COUNT(*) AS players
FROM players
GROUP BY age_group
ORDER BY avg_rating DESC;