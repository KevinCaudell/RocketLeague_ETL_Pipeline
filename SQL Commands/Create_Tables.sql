-- Create Replays Table

IF OBJECT_ID('dbo.Replays', 'U') IS NULL
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


-- Create Players Table

IF OBJECT_ID('dbo.Players', 'U') IS NULL
BEGIN
    CREATE TABLE Players(
        player_id        VARCHAR(200) PRIMARY KEY,
        player_name      VARCHAR(200),
        platform         VARCHAR(30)
    );
END
GO

-- Create Match Stats Table

IF OBJECT_ID('dbo.Match_Stats', 'U') IS NULL
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