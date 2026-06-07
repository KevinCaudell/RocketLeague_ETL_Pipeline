-- 1. DROP GOLD LAYER (These depend on fact and dimension tables)
IF OBJECT_ID('dbo.gold_Daily_Metrics', 'U') IS NOT NULL 
    DROP TABLE dbo.gold_Daily_Metrics;
GO
IF OBJECT_ID('dbo.gold_Season_Performance', 'U') IS NOT NULL 
    DROP TABLE dbo.gold_Season_Performance;
GO
IF OBJECT_ID('dbo.gold_Playlist_Performance', 'U') IS NOT NULL 
    DROP TABLE dbo.gold_Playlist_Performance;
GO
IF OBJECT_ID('dbo.gold_Map_Performance', 'U') IS NOT NULL 
    DROP TABLE dbo.gold_Map_Performance;
GO
IF OBJECT_ID('dbo.gold_Player_Performance', 'U') IS NOT NULL 
    DROP TABLE dbo.gold_Player_Performance;
GO

-- 2. DROP FACT LAYER (Must drop Match Stats before Replays because it references replay_id)
IF OBJECT_ID('dbo.fact_Match_Stats', 'U') IS NOT NULL 
    DROP TABLE dbo.fact_Match_Stats;
GO
IF OBJECT_ID('dbo.fact_Replays', 'U') IS NOT NULL 
    DROP TABLE dbo.fact_Replays;
GO

-- 3. DROP DIMENSION LAYER (Safe to drop now that no tables reference them)
IF OBJECT_ID('dbo.dim_Players', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_Players;
GO
IF OBJECT_ID('dbo.dim_Seasons', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_Seasons;
GO
IF OBJECT_ID('dbo.dim_Dates', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_Dates;
GO
IF OBJECT_ID('dbo.dim_Playlists', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_Playlists;
GO
IF OBJECT_ID('dbo.dim_Maps', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_Maps;
GO