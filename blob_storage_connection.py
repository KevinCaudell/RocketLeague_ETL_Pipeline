from azure.storage.blob import BlobServiceClient

def upload_to_blob(container_name, file_path, blob_name, conn_string):

    blob_service_client = BlobServiceClient.from_connection_string(conn_string)

    blob_client = blob_service_client.get_blob_client(
        container=container_name,
        blob=blob_name
    )

    with open(file_path, 'rb') as data:
        blob_client.upload_blob(data, overwrite=True)

    print(f"Uploaded {file_path} → {container_name}/{blob_name}")
