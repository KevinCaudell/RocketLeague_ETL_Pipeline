-- Create dim_Maps (DIMENSION)

IF OBJECT_ID('dbo.dim_Maps', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Maps(
        map_id INT PRIMARY KEY,
        map_name VARCHAR(100) NOT NULL UNIQUE
    );
END
GO

-- Create dim_Playlists (DIMENSION)

IF OBJECT_ID('dbo.dim_Playlists', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Playlists(
        playlist_id INT PRIMARY KEY,
        playlist_name VARCHAR(100) NOT NULL UNIQUE
    );
END
GO

-- Create dim_Dates (DIMENSION)

IF OBJECT_ID('dbo.dim_Dates', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Dates(
        date_id DATE PRIMARY KEY
    );
END
GO

-- Create dim_Seasons (DIMENSION)

IF OBJECT_ID('dbo.dim_Seasons', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Seasons(
        season_id INT PRIMARY KEY,
        season_number INT NOT NULL UNIQUE,
        season_type VARCHAR(30) NOT NULL UNIQUE
    );
END
GO

-- Create dim_Players Table (DIMENSION)

IF OBJECT_ID('dbo.dim_Players', 'U') IS NULL
BEGIN
    CREATE TABLE dim_Players(
        player_id        VARCHAR(200) PRIMARY KEY,
        player_name      VARCHAR(200),
        platform         VARCHAR(30)
    );
END
GO

-- Create Replays Table (FACT)

IF OBJECT_ID('dbo.fact_Replays', 'U') IS NULL
BEGIN
    CREATE TABLE fact_Replays(
        replay_id        VARCHAR(200) PRIMARY KEY,
        rocket_league_id VARCHAR(200) UNIQUE,
        replay_title     VARCHAR(300),
        match_duration   INT NOT NULL,
        blue_goals       INT NOT NULL,
        orange_goals     INT NOT NULL,
        winner           VARCHAR(6) NOT NULL,

        map_id INT NOT NULL,
        playlist_id INT NOT NULL,
        season_id INT NOT NULL,
        date_id DATE NOT NULL,

        FOREIGN KEY (map_id) REFERENCES dim_Maps(map_id),
        FOREIGN KEY (playlist_id) REFERENCES dim_Playlists(playlist_id),
        FOREIGN KEY (season_id) REFERENCES dim_Seasons(season_id),
        FOREIGN KEY (date_id) REFERENCES dim_Dates(date_id)
        
        -- Fixed: Ensured clean standard spaces and removed the trailing comma here
        CONSTRAINT chk_winner CHECK (winner IN ('Blue', 'Orange', 'Tie')) 
    );
END
GO

-- Create Match Stats Table (FACT)

IF OBJECT_ID('dbo.fact_Match_Stats', 'U') IS NULL
BEGIN
    CREATE TABLE fact_Match_Stats(
        replay_id        VARCHAR(200) NOT NULL,
        player_id        VARCHAR(200) NOT NULL,
        team             VARCHAR(6) NOT NULL,
        score            BIGINT NOT NULL,
        mvp              BIT NOT NULL,
        start_time       DECIMAL(10,2) NOT NULL,
        end_time         DECIMAL(10,2) NOT NULL,

        FOREIGN KEY (replay_id) REFERENCES fact_Replays(replay_id),
        FOREIGN KEY (player_id) REFERENCES dim_Players(player_id)
    );
END
GO

-- Create Players Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Player_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Player_Performance(
        player_id VARCHAR(200) PRIMARY KEY,
        matches_played INT NOT NULL,
        wins INT NOT NULL,
        losses INT NOT NULL,
        ties INT NOT NULL,
        win_rate DECIMAL(5,2) NOT NULL,
        avg_score DECIMAL(10,2) NOT NULL,
        total_score BIGINT NOT NULL,
        mvp_count INT NOT NULL,
        mvp_rate DECIMAL(5,2) NOT NULL,
        avg_play_time DECIMAL(10,2) NOT NULL,

        FOREIGN KEY (player_id) references dim_Players(player_id)
    );
END
GO

-- Create Map Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Map_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Map_Performance(
        map_id INT PRIMARY KEY,
        matches_played INT NOT NULL,
        avg_goals DECIMAL(10,2) NOT NULL,
        avg_duration DECIMAL(10,2) NOT NULL,

        FOREIGN KEY (map_id) references dim_Maps(map_id)
    );
END
GO

-- Create Playlist Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Playlist_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Playlist_Performance(
        playlist_id INT PRIMARY KEY,
        matches_played INT NOT NULL,
        avg_match_duration DECIMAL(10,2) NOT NULL,
        avg_total_goals DECIMAL(10,2) NOT NULL,
        blue_win_rate DECIMAL(5,2) NOT NULL,
        orange_win_rate DECIMAL(5,2) NOT NULL,

        FOREIGN KEY (playlist_id) references dim_Playlists(playlist_id)
    );
END
GO

-- Create Season Performance Table (GOLD)

IF OBJECT_ID('dbo.gold_Season_Performance', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Season_Performance(
        season_id INT PRIMARY KEY,
        matches_played INT NOT NULL,
        avg_goals DECIMAL(10,2) NOT NULL,
        unique_players INT NOT NULL,

        FOREIGN KEY (season_id) references dim_Seasons(season_id)
    );
END
GO

-- Create Daily Metrics Table (GOLD)

IF OBJECT_ID('dbo.gold_Daily_Metrics', 'U') IS NULL
BEGIN
    CREATE TABLE gold_Daily_Metrics(
        date_id DATE PRIMARY KEY,
        matches_played INT NOT NULL,
        unique_players INT NOT NULL,
        avg_score DECIMAL(10,2) NOT NULL,
        avg_goals DECIMAL(10,2) NOT NULL,

        FOREIGN KEY (date_id) references dim_Dates(date_id)
    );
END
GO