"""
LEGACY MODULE: dbLoader.py

This file contains the original SQL Server loading layer of the 
Rocket League analytics pipeline before migration to Azure Databricks.

In the initial version of the project, this module was responsible for:

- Establishing a direct connection to an Azure SQL Database using pyodbc
- Pulling transformed data from pipeline_utils.py:
    - Replays data
    - Players data
    - Match Stats data
- Performing UPSERT (MERGE) operations into SQL tables:
    - Replays
    - Players
    - Match_Stats
- Handling full end-to-end loading logic including:
    - Insert / update logic per record
    - Error handling per table (success/failure tracking)
    - Transaction management (commit / rollback)
    - Pipeline execution summary logging

Each dataset was iterated row-by-row and inserted using parameterized MERGE
statements to ensure upserts into Azure SQL.

After migration to Azure Databricks, this approach was replaced by:
- Bronze/Silver/Gold layered architecture
- Distributed data processing using Spark DataFrames
- Decoupled ingestion via RL_API.py and blob storage
- Databricks-based transformations instead of direct SQL upserts

This module is now deprecated and kept for historical reference only.
It should NOT be used in the current production pipeline.
"""

import pyodbc
from pipeline_utils import loadReplayData, loadPlayerData, loadMatchStatsData

def loadToDB():
    SERVER = '<Azure Database Server>'
    DATABASE = '<Azure SQL Database Name>'
    ADMIN = '<Username>'
    PASSWORD = '<Password>'

    conn = pyodbc.connect(
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={SERVER};"
        f"DATABASE={DATABASE};"
        f"UID={ADMIN};"
        f"PWD={PASSWORD};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
    )

    cursor = conn.cursor()
    print('Connected to database successfull!')

    Replays = loadReplayData()
    Players = loadPlayerData()
    Match_Stats = loadMatchStatsData()

    def upsertPlayer(record):
        cursor.execute("""
            MERGE Players as target
            USING (
                SELECT 
                ? AS player_id,
                ? AS player_name, 
                ? AS platform
                ) AS source
            ON target.player_id = source.player_id
                    
            WHEN MATCHED THEN
                UPDATE SET
                    player_name = source.player_name,
                    platform = source.platform
                    
            WHEN NOT MATCHED THEN
                INSERT (player_id, player_name, platform)
                VALUES (source.player_id, source.player_name, source.platform);
        """,
        record["player_id"],
        record["player_name"],
        record["platform"]
        )

    def upsertReplay(record):
        cursor.execute("""
            MERGE Replays as target
            USING (
                Select 
                ? AS replay_id, 
                ? AS rocket_league_id,
                ? AS replay_title,
                ? AS map_name,
                ? AS playlist,
                ? AS match_duration,
                ? AS season,
                ? AS season_type,
                ? AS date_time,
                ? AS blue_goals,
                ? AS orange_goals,
                ? AS winner
                ) AS source
            ON target.replay_id = source.replay_id
                    
            WHEN MATCHED THEN
                UPDATE SET
                    rocket_league_id = source.rocket_league_id,
                    replay_title = source.replay_title,
                    map_name = source.map_name,
                    playlist = source.playlist,
                    match_duration = source.match_duration,
                    season = source.season,
                    season_type = source.season_type,
                    date_time = source.date_time,
                    blue_goals = source.blue_goals,
                    orange_goals = source.orange_goals,
                    winner = source.winner
            
            WHEN NOT MATCHED THEN
                INSERT (
                    replay_id,
                    rocket_league_id,
                    replay_title,
                    map_name,
                    playlist,
                    match_duration,
                    season,
                    season_type,
                    date_time,
                    blue_goals,
                    orange_goals,
                    winner
                )
                VALUES(
                    source.replay_id,
                    source.rocket_league_id,
                    source.replay_title,
                    source.map_name,
                    source.playlist,
                    source.match_duration,
                    source.season,
                    source.season_type,
                    source.date_time,
                    source.blue_goals,
                    source.orange_goals,
                    source.winner
                );
                    
        """,
        record["replay_id"],
        record["rocket_league_id"],
        record["replay_title"],
        record["map_name"],
        record["playlist_type"],
        record["match_duration"],
        record["season"],
        record["season_type"],
        record["date"],
        record["blue_goals"],
        record["orange_goals"],
        record["winner"]
        )

    def upsertMatchStats(record):
        cursor.execute("""
            MERGE Match_Stats AS target
            USING (
                SELECT
                    ? AS replay_id,
                    ? AS player_id,
                    ? AS team,
                    ? AS score,
                    ? AS mvp,
                    ? AS start_time,
                    ? AS end_time
            ) AS source

            ON target.replay_id = source.replay_id
            AND target.player_id = source.player_id

            WHEN MATCHED THEN
                UPDATE SET
                    team = source.team,
                    score = source.score,
                    mvp = source.mvp,
                    start_time = source.start_time,
                    end_time = source.end_time

            WHEN NOT MATCHED THEN
                INSERT (
                    replay_id,
                    player_id,
                    team,
                    score,
                    mvp,
                    start_time,
                    end_time
                )
                VALUES (
                    source.replay_id,
                    source.player_id,
                    source.team,
                    source.score,
                    source.mvp,
                    source.start_time,
                    source.end_time
                );
        """,
        record["replay_id"],
        record["player_id"],
        record["team"],
        record["score"],
        record["mvp"],
        record["start_time"],
        record["end_time"]
        )

    def insertReplays(data):
        Success = 0
        Failed = 0
        for record in data:
            try:
                upsertReplay(record)
                Success += 1
            except Exception as e:
                print("\nREPLAY FAILED")
                print(f"Replay ID: {record['replay_id']}")
                print(f"Winner: {record['winner']}")
                print(f"Full Record: {record}")
                print(e)
                #print(f'Replay insert failed: "{record["replay_id"]}" {e}')
                Failed += 1

        return (Success, Failed)

    def insertPlayers(data):
        Success = 0
        Failed = 0

        for record in data:
            try:
                upsertPlayer(record)
                Success += 1

            except Exception as e:
                print(f'Player insert failed: "{record["player_id"]}" {e}')
                Failed += 1

        return (Success, Failed)

    def insertMatchStats(data):
        Success = 0
        Failed = 0
        for record in data:
            try:
                upsertMatchStats(record)
                Success += 1
            except Exception as e:
                print(f'Match Stat insert failed: "{record["replay_id"]}, {record["player_id"]}" {e}')
                Failed += 1
        return (Success, Failed)


    Replay_Success = Replay_Failed = 0
    Player_Success = Player_Failed = 0
    MS_Success = MS_Failed = 0

    try: 
        Replay_Success, Replay_Failed = insertReplays(Replays)
        Player_Success, Player_Failed = insertPlayers(Players)
        MS_Success, MS_Failed = insertMatchStats(Match_Stats)

        conn.commit()
        print('All data inserted successfully')

    except Exception as e:
        conn.rollback()
        print("Pipeline failed:", e)

    finally:
        conn.close()

    print("\nPIPELINE SUMMARY")
    print("----------------")
    print(f"REPLAYS:      Success={Replay_Success}, Failed={Replay_Failed}")
    print(f"PLAYERS:      Success={Player_Success}, Failed={Player_Failed}")
    print(f"MATCH_STATS:  Success={MS_Success}, Failed={MS_Failed}")