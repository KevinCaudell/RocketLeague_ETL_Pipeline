-- Create dim_Maps (DIMENSION)

IF OBJECT_ID('dbo.dim_Maps', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Maps(
        
    );
END
GO

-- Create dim_Playlists (DIMENSION)

IF OBJECT_ID('dbo.dim_Playlists', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Playlists(
        
    );
END
GO

-- Create dim_Dates (DIMENSION)

IF OBJECT_ID('dbo.dim_Dates', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Dates(
        
    );
END
GO

-- Create dim_Seasons (DIMENSION)

IF OBJECT_ID('dbo.dim_Seasons', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Seasons(
        
    );
END
GO

-- Create dim_Players Table (DIMENSION)

IF OBJECT_ID('dbo.dim_Players', 'U') IS NULL
BEGIN
    CREATE TABLE Players(
        player_id        VARCHAR(200) PRIMARY KEY,
        player_name      VARCHAR(200),
        platform         VARCHAR(30)
    );
END
GO

-- Create Replays Table (FACT)

IF OBJECT_ID('dbo.fact_Replays', 'U') IS NULL
BEGIN
    CREATE TABLE Replays(
        replay_id        VARCHAR(200) PRIMARY KEY,
        rocket_league_id VARCHAR(200) UNIQUE,
        replay_title     VARCHAR(300),
        map_name         VARCHAR(100),
        playlist         VARCHAR(100),
        match_duration   INT NOT NULL,
        season           INT NOT NULL,
        season_type      VARCHAR(50) NOT NULL,
        date_time        DATETIME2 NOT NULL,
        blue_goals       INT NOT NULL,
        orange_goals     INT NOT NULL,
        winner           VARCHAR(6) NOT NULL,
        
        -- Fixed: Ensured clean standard spaces and removed the trailing comma here
        CONSTRAINT chk_winner CHECK (winner IN ('Blue', 'Orange', 'Tie')) 
    );
END
GO

-- Create Match Stats Table (FACT)

IF OBJECT_ID('dbo.fact_Match_Stats', 'U') IS NULL
BEGIN
    CREATE TABLE Match_Stats(
        replay_id        VARCHAR(200) NOT NULL,
        player_id        VARCHAR(200) NOT NULL,
        team             VARCHAR(6) NOT NULL,
        score            BIGINT NOT NULL,
        mvp              BOOLEAN NOT NULL,
        start_time       DECIMAL(10,2) NOT NULL,
        end_time         DECIMAL(10,2) NOT NULL,

        FOREIGN KEY (replay_id) REFERENCES Replays(replay_id),
        FOREIGN KEY (player_id) REFERENCES Players(player_id)
    );
END
GO

-- Create Players Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Player_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Player_Performance(
        
    );
END
GO

-- Create Map Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Map_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Map_Performance(
        
    );
END
GO

-- Create Playlist Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Playlist_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Playlist_Performance(
        
    );
END
GO

-- Create Season Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Season_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Season_Performance(
        
    );
END
GO

-- Create Daily Metrics Table (GOLD)

IF OBJECT_ID('dbo.gold_Daily_Metrics', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Daily_Metrics(
        
    );
END
GO