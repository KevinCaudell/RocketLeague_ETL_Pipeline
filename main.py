import RL_API
import pipeline_utils as pu
import blob_storage_connection as blob
from datetime import datetime

from config import Config

WORKSPACE_URL = Config.DATABRICKS_WORKSPACE_URL
TOKEN = Config.DATABRICKS_TOKEN
JOB_ID = Config.DATABRICKS_JOB_ID
BLOB_CONN_STRING = Config.AZURE_BLOB_STORAGE_CONNECTION_STRING
API_TOKEN = Config.BALLCHASING_API_TOKEN
API_BASE_URL = Config.BALLCHASING_API_BASE_URL

def main():
    print('Welcome to my first pipeline!')
    print('Rocket League tracker edition')
    print('-' * 30, '\n\n')

    while True:
        try:
            num_replays = int(input('Number of replays to process (Max = 10000): '))
        except ValueError:
            print('Invalid input. Please enter a whole number.')
            continue

        ##### Runs API (Ingestion) #####
        loaded_data = RL_API.runAPI(
            token=API_TOKEN, 
            base_url=API_BASE_URL,
            max_replays=num_replays)
        
        if not loaded_data:
            print('\n\nNumber of replays to process must be below 10000 and above 50!\n\n')
            continue
        break

    RL_API.writeRawJSON(loaded_data)

    timestamp_bronze = datetime.now().strftime("%Y%m%d_%H%M%S")

    blob.upload_to_blob(
        container_name="bronze-raw-data", 
        file_path="jsonFiles/raw_replays.json", 
        blob_name=f"replays/raw_replays_{timestamp_bronze}.json",
        conn_string=BLOB_CONN_STRING
        )

    #########################################################

    ##### Run Databricks Job #####

    run_id = pu.triggerDatabrickJob(
        workspace_url=WORKSPACE_URL,
        token=TOKEN,
        job_id=JOB_ID
    )

    print(f'Databricks run started: {run_id}')

    success = pu.wait_for_Databricks_run(
        workspace_url=WORKSPACE_URL,
        token=TOKEN,
        run_id=run_id
        )

    if success:
        print("PIPELINE COMPLETE")
    else:
        print("PIPELINE FAILED")


    ########################################################

if __name__ == "__main__":
    main()