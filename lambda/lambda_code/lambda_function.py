import os
import json
from google.cloud import storage

def lambda_handler(event, context):
    try:
        # The storage.Client() will automatically pick up credentials
        # from the GOOGLE_APPLICATION_CREDENTIALS environment variable
        # and the project from GOOGLE_CLOUD_PROJECT.
        client = storage.Client()

        bucket_name = os.environ.get('gcs_bucket_name')
        # Example: List objects in the bucket
        blobs = client.list_blobs(bucket_name)
        object_names = [blob.name for blob in blobs]

        # Example: Download a specific object
        # blob_name = "" # Replace with an actual object name
        # bucket = client.bucket(bucket_name)
        # blob = bucket.blob(blob_name)
        # content = blob.download_as_text()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Successfully listed objects in bucket {bucket_name}",
                "objects": object_names
                # "downloaded_content": content # Uncomment if you want to download and return content
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error: {str(e)}"
        }