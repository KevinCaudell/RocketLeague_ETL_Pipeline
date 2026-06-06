"""
LEGACY MODULE: Legacy_Pipeline_Utils.py

This file contains the original local ETL transformation layer of the Rocket League
analytics pipeline prior to migration to Azure Databricks.

In the initial Python-based pipeline architecture, this module handled the full
data preparation workflow including:

DATA LOADING (LOCAL FILE-BASED STAGING):
- Reading raw API output from JSON files (raw_replays.json)
- Loading previously transformed JSON datasets:
    - Replay_Records.json
    - Player_Records.json
    - Match_Stats_Records.json

TRANSFORMATION LOGIC (LOCAL SILVER-LIKE PROCESSING):
- transform_Replays():
    - Extracted replay-level metadata from nested API structure
    - Computed match outcomes (blue vs orange winner logic)
    - Normalized replay fields into structured records

- transform_Players():
    - Flattened nested player data from both teams
    - Deduplicated players across multiple replays
    - Built a unique player dimension-style dataset

- transform_Match_Stats():
    - Created per-player match statistics records
    - Extracted score, MVP status, and timing data
    - Flattened nested team structures into row-level facts

FILE PERSISTENCE (LOCAL STORAGE LAYER):
- Wrote cleaned datasets back to JSON files:
    - Replay_Records.json
    - Player_Records.json
    - Match_Stats_Records.json

- Reloaded cleaned datasets for downstream database loading

PIPELINE ROLE (PRE-DATABRICKS ARCHITECTURE):
This module functioned as the "silver layer" equivalent before the adoption of:
- Azure Databricks (Spark-based transformations)
- Bronze/Silver/Gold medallion architecture
- Cloud-based distributed processing

After migration, these responsibilities were replaced by:
- Databricks notebooks for scalable transformations

This module is now deprecated and retained for historical reference only.
It should NOT be used in the active production pipeline.
"""

import time
import json

def loadData():
    """Loads data from saved Raw Replay JSON file"""
    with open('jsonFiles/raw_replays.json', 'r') as file:
        loaded_data = json.load(file)
    
    print('Raw Replay loaded back into memory!')
    time.sleep(1)
    return loaded_data

def writeCleanedData(file_type, cleaned_data):
    """Writes Cleaned Data to file based on file type"""
    if file_type == 'R':
        with open('jsonFiles/Replay_Records.json', 'w') as file:
            json.dump(cleaned_data, file, indent=4)

        print('Replay Records created')
        time.sleep(1)
        return 'jsonFiles/Replay_Records.json'

    elif file_type == 'P':
        with open('jsonFiles/Player_Records.json', 'w') as file:
            json.dump(cleaned_data, file, indent=4)

        print('Player Records created')
        time.sleep(1)
        return 'jsonFiles/Player_Records.json'

    elif file_type == 'M':
        with open('jsonFiles/Match_Stats_Records.json', 'w') as file:
            json.dump(cleaned_data, file, indent=4)
            
        print('Match Stat Records created')
        time.sleep(1)
        return 'jsonFiles/Match_Stats_Records.json'

    else:
        print('Incorrect file_type')   

def transform_Replays(data):
    replays = []
    for rp in data["list"]:
        blue_goals = rp["blue"].get("goals", 0)
        orange_goals = rp["orange"].get("goals", 0)

        if blue_goals > orange_goals:
            winner = 'blue'
        elif orange_goals > blue_goals:
            winner = 'orange'
        else:
            winner = 'tie'

        temp_replay = {
        "replay_id": rp['id'],
        "rocket_league_id": rp["rocket_league_id"],
        "replay_title": rp["replay_title"],
        "map_name": rp.get("map_name", None),
        "playlist_type": rp.get("playlist_name", None),
        "match_duration": rp['duration'],
        "season": rp["season"],
        "season_type": rp["season_type"],
        "date": rp["date"],
        "blue_goals": blue_goals,
        "orange_goals": orange_goals,
        "winner": winner
        }
        replays.append(temp_replay)

    print('Replays cleaned!')
    time.sleep(1)
    return ('R', replays)

def transform_Players(data):
    players = {}

    for rp in data["list"]:
        rp_bp = rp.get("blue", {}).get("players", [])
        rp_op = rp.get("orange", {}).get("players", [])

        for player in rp_bp: # loop through blue team

            if "id" not in player or "id" not in player["id"]: # Checks if player has ID
                continue

            player_id = player['id']['id']

            players[player_id] = {
                "player_id": player_id,
                "player_name": player["name"],
                "platform": player["id"]["platform"]
            }

        for player in rp_op: # loop through orange team

            if "id" not in player or "id" not in player["id"]: # Checks if player has ID
                continue

            player_id = player['id']['id']

            players[player_id] = {
                "player_id": player_id,
                "player_name": player["name"],
                "platform": player["id"]["platform"]
            }
    
    print('Players cleaned!')
    time.sleep(1)
    return ('P', list(players.values()))

def transform_Match_Stats(data):
    match_stats = []
    for rp in data["list"]:
        rp_bp = rp.get("blue", {}).get("players", [])
        rp_op = rp.get("orange", {}).get("players", [])

        for player in rp_bp: # blue players

            if "id" not in player or "id" not in player["id"]: # Checks if player has ID
                continue

            temp_match_stats = {
                "replay_id": rp["id"],
                "player_id": player["id"]["id"],
                "team": 'blue',
                "score": player["score"],
                "mvp": player.get("mvp", False),
                "start_time": round(player["start_time"], 2),
                "end_time": round(player["end_time"], 2)
            }
            match_stats.append(temp_match_stats)

        for player in rp_op: # orange players

            if "id" not in player or "id" not in player["id"]: # Checks if player has ID
                continue

            temp_match_stats = {
                "replay_id": rp["id"],
                "player_id": player["id"]["id"],
                "team": 'orange',
                "score": player["score"],
                "mvp": player.get("mvp", False),
                "start_time": round(player["start_time"], 2),
                "end_time": round(player["end_time"], 2)
            }
            match_stats.append(temp_match_stats)
    
    print('Match Stats cleaned!')
    time.sleep(1)
    return ('M', match_stats)

def loadReplayData():
    with open('jsonFiles/Replay_Records.json', 'r') as file:
        replay_data = json.load(file)
    
    print('Loaded Cleaned Replay Data')
    time.sleep(1)
    return replay_data

def loadPlayerData():
    with open('jsonFiles/Player_Records.json', 'r') as file:
        player_data = json.load(file)
    
    print('Loaded Cleaned Player Data')
    time.sleep(1)
    return player_data

def loadMatchStatsData():
    with open('jsonFiles/Match_Stats_Records.json', 'r') as file:
        match_stats_data = json.load(file)
        
    print('Loaded Cleaned Match Stats Data')
    time.sleep(1)
    return match_stats_data
    
