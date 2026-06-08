import time
import requests

def triggerDatabrickJob(workspace_url, token, job_id):
    headers = {
        "Authorization": f"Bearer {token}"
    }

    payload = {
        "job_id": job_id
    }

    url = f'{workspace_url}/api/2.1/jobs/run-now'
    
    res = requests.post(url, headers=headers, json=payload)

    return res.json()["run_id"]

def wait_for_Databricks_run(workspace_url, token, run_id, timeout=1000):
    url = f"{workspace_url}/api/2.1/jobs/runs/get"

    headers = {
        "Authorization": f'Bearer {token}'
    }

    start_time = time.time()

    while True:
        response = requests.get(url, headers=headers, params={"run_id": run_id})
        data = response.json()

        state = data["state"]["life_cycle_state"]
        result = data["state"].get("result_state")

        print(f"State: {state}, Result: {result}")

        # SUCCESS
        if state == "TERMINATED" and result == "SUCCESS":
            print("Databricks job succeeded")
            return True

        # FAILURE
        if state == "TERMINATED" and result != "SUCCESS":
            print("Databricks job failed")
            print(data)
            return False

        # TIMEOUT CHECK
        if time.time() - start_time > timeout:
            print("Timeout waiting for Databricks job")
            return False

        time.sleep(10)
