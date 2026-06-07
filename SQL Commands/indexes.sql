-- Match Stats Table Indexes

CREATE INDEX idx_Match_Stats_player_id
ON fact_Match_Stats (player_id);
GO

CREATE INDEX idx_Match_Stats_player_id
ON fact_Match_Stats (replay_id);
GO

CREATE INDEX idx_Match_Stats_team
ON fact_Match_Stats
 (team);
GO

-- Replays Table Indexes

CREATE INDEX idx_Replays_map_id
ON fact_Replays (map_id);
GO

CREATE INDEX idx_Replays_playlist_id
ON fact_Replays (playlist_id);
GO

CREATE INDEX idx_Replays_season_id
ON fact_Replays (season_id);
GO

CREATE INDEX idx_Replays_date_id
ON fact_Replays (date_id);
GO

-- Dimension Table Indexes

CREATE INDEX idx_maps_name
ON dim_Maps (map_name);
GO

CREATE INDEX idx_playlists_name
ON dim_Playlists (playlist_name);
GO

CREATE INDEX idx_players_name
ON dim_Players(player_name);
GO

CREATE INDEX idx_players_platform
ON dim_Players(platform);
GO

-- Gold Table Indexes

CREATE INDEX idx_gold_player_perf
ON gold_Player_Performance(player_id);
GO

CREATE INDEX idx_gold_daily_metrics
ON gold_Daily_Metrics(date_id);
GO