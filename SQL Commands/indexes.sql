/* =========================
   FACT: Match Stats Indexes
   ========================= */

-- Fast lookup by player
CREATE INDEX idx_matchstats_player_id
ON fact_Match_Stats (player_id);
GO

-- Fast lookup by replay
CREATE INDEX idx_matchstats_replay_id
ON fact_Match_Stats (replay_id);
GO

-- Composite index for main join pattern (VERY IMPORTANT)
-- Used for: replay → players aggregation queries
CREATE INDEX idx_matchstats_replay_player
ON fact_Match_Stats (replay_id, player_id);
GO

-- Team filtering (optional but useful for analytics)
CREATE INDEX idx_matchstats_team
ON fact_Match_Stats (team);
GO


/* =========================
   FACT: Replays Indexes
   ========================= */

CREATE INDEX idx_replays_map_id
ON fact_Replays (map_id);
GO

CREATE INDEX idx_replays_playlist_id
ON fact_Replays (playlist_id);
GO

CREATE INDEX idx_replays_season_id
ON fact_Replays (season_id);
GO

CREATE INDEX idx_replays_date_id
ON fact_Replays (date_id);
GO

-- Optional: useful for win-rate dashboards
CREATE INDEX idx_replays_winner
ON fact_Replays (winner);
GO


/* =========================
   DIMENSIONS Indexes
   ========================= */

-- Maps
CREATE INDEX idx_maps_name
ON dim_Maps (map_name);
GO

-- Playlists
CREATE INDEX idx_playlists_name
ON dim_Playlists (playlist_name);
GO

-- Players
CREATE INDEX idx_players_name
ON dim_Players (player_name);
GO

CREATE INDEX idx_players_platform
ON dim_Players (platform);
GO


/* =========================
   GOLD Indexes
   ========================= */

-- Player performance lookup
CREATE INDEX idx_gold_player_perf_player
ON gold_Player_Performance (player_id);
GO

-- Daily metrics time-series queries
CREATE INDEX idx_gold_daily_metrics_date
ON gold_Daily_Metrics (date_id);
GO