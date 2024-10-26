
# SQLs

See [init script](scripts/init.sh) for the SQL model.


```sql
-- TOP 5 per Score
SELECT TOP 5 
    U.username, 
    SUM(S.points) AS total_points
FROM 
    Users U
    JOIN ScoreBoard S ON U.username = S.username
GROUP BY 
    U.username
ORDER BY 
    total_points DESC;
GO


-- Worst 5
SELECT TOP 5 
    U.username, 
    SUM(ISNULL(S.points, 0)) AS total_points
FROM 
    Users U
    LEFT JOIN ScoreBoard S ON U.username = S.username
GROUP BY 
    U.username
ORDER BY 
    total_points ASC;
GO

-- Most games played by User, top 5
SELECT TOP 5
    U.username,
    COUNT(S.Id) AS number_of_games
FROM 
    Users U
    LEFT JOIN ScoreBoard S ON U.username = S.username
GROUP BY 
    U.username;
GO
```