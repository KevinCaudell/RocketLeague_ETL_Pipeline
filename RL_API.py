import requests as req
import json
import time

def runAPI(token, base_url, max_replays=10000):
    """Fetches all replay pages from Ballchasing"""

    if max_replays > 10000 or max_replays < 50:
        return False

    headers = {
        "Authorization": token
    }
    url = base_url

    all_replays = []
    page = 1

    while url and len(all_replays) < max_replays:
        res = req.get(url, headers=headers)
        res.raise_for_status()

        data = res.json()

        replay_count = len(data["list"])

        all_replays.extend(data["list"])

        print(
            f"Page {page}: "
            f"{replay_count} replays "
            f"(Total: {len(all_replays)})"
        )

        url = data.get("next")
        page += 1

    print(f"\nFinished loading {len(all_replays)} replays")
    time.sleep(1)

    return {
    "count": len(all_replays),
    "list": all_replays
    }
    
def writeRawJSON(data):
    """Writes to JSON file"""
    with open('jsonFiles/raw_replays.json', 'w') as file:
        json.dump(data, file, indent=4)
    print('\nRaw Replays successfully saved to JSON file!\n')
    time.sleep(1)
