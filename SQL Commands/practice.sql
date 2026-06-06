-- Level 1

-- 1. What tables exist in my database, and what are their names?
select name
from sys.tables;

-- 2. What does the structure of the Replays table look like? (columns, types, nullability)
select COLUMN_NAME, DATA_TYPE, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Replays'
and TABLE_SCHEMA = 'dbo';

-- 3. How many total replays are stored in the database?
select count(*) as 'Replay Count'
from Replays;

--Level 2

-- 4. Are there any NULL values in map_name, playlist, or replay_title?
select count(map_name) as 'Map Name', count(playlist) as 'Playlist', count(replay_title) as 'Replay Title'
from Replays
where map_name is NULL or playlist is NULL or replay_title is NULL;

-- 5. Which columns in the Replays Table contain the most missing data?
select 
    count(rocket_league_id), 
    count(replay_title),
    count(map_name),
    count(playlist)
from Replays
where 
    rocket_league_id is NULL
    or replay_title is NULL
    or map_name is NULL
    or playlist is NULL;

-- 6. Are there any duplicate rocket_league_id values (even though it should be UNIQUE)?
select rocket_league_id, count(*)
from Replays
group by rocket_league_id
having count(*) > 1;

-- Level 3

-- 7. How many replays are there per map?
select map_name, count(replay_id)
from Replays
group by map_name
order by map_name desc;

-- 8. What are the most common playlists?
select top (3) playlist, count(playlist)
from Replays
group by playlist
order by count(playlist) desc;

-- 9. What is the average match duration?
select avg(match_duration) as 'Average Duration'
from Replays;

-- 9.1. What is the average match duration for each playlist (DONT SHOW NULL values)?
select playlist as Playlist, avg(match_duration) as 'Average Duration'
from Replays
where playlist is not NULL
group by playlist
order by 'Average Duration' desc;

-- Level 4

-- 10. How many replays were played per day/week?

---- By Day
SELECT 
    CAST(date_time AS DATE) AS match_date,
    COUNT(replay_id) AS total_replays
FROM Replays
GROUP BY CAST(date_time AS DATE)
ORDER BY match_date DESC;

---- By Week
SELECT 
    DATETRUNC(week, date_time) AS week_starting,
    COUNT(replay_id) AS total_replays
FROM Replays
GROUP BY DATETRUNC(week, date_time)
ORDER BY week_starting DESC;


-- 11. What was the longest match recorded?
select TOP 1 *
from Replays
where match_duration = (
    select max(match_duration)
    from Replays
);

-- Level 5

-- 12. Which replays are missing key fields that would break analytics pipelines?
SELECT *
FROM Replays
WHERE replay_title IS NULL OR replay_title = ''
   OR map_name IS NULL OR map_name = ''
   OR playlist IS NULL OR playlist = ''
   OR match_duration IS NULL
   OR season IS NULL
   OR rocket_league_id IS NULL OR rocket_league_id = '';

-- 13. If I had to create a “cleaned replays” table, what rules would I apply?

-- 14. What percentage of my data is “usable” for analysis?

-- Challenge

-- 15. If I had to build a dashboard, what 5 metrics would I calculate from this table? Write the SQL for one of them.