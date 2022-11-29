import os
import ibm_boto3
from ibm_botocore.client import Config, ClientError

# Constants for IBM COS values
COS_ENDPOINT = "https://"+"s3.eu-de.cloud-object-storage.appdomain.cloud" # Current list avaiable at https://control.cloud-object-storage.cloud.ibm.com/v2/endpoints
COS_API_KEY_ID = "<apikey>" # eg "W00YixxxxxxxxxxMB-odB-2ySfTrFBIQQWanc--P3byk"
COS_INSTANCE_CRN = "<>" # eg "crn:v1:bluemix:public:cloud-object-storage:global:a/3bf0d9003xxxxxxxxxx1c3e97696b71c:d6f04d83-6c4f-4a62-a165-696756d63903::"

# Create resource
cos_resource = ibm_boto3.resource("s3",
    ibm_api_key_id=COS_API_KEY_ID,
    ibm_service_instance_id=COS_INSTANCE_CRN,
    config=Config(signature_version="oauth"),
    endpoint_url=COS_ENDPOINT
)

# Create client 
cos_client = ibm_boto3.client("s3",
    ibm_api_key_id=COS_API_KEY_ID,
    ibm_service_instance_id=COS_INSTANCE_CRN,
    config=Config(signature_version="oauth"),
    endpoint_url=COS_ENDPOINT
)
# "eu-de-standard"
def create_bucket(bucket_name, location):
    print("Creating new bucket: {0}".format(bucket_name))
    try:
        cos_resource.Bucket(bucket_name).create(
            CreateBucketConfiguration={
                "LocationConstraint": location
            }
        )
        print("Bucket: {0} created!".format(bucket_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to create bucket: {0}".format(e))

def get_buckets():
    print("Retrieving list of buckets")
    try:
        buckets = cos_resource.buckets.all()
        for bucket in buckets:
            print("Bucket Name: {0}".format(bucket.name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to retrieve list buckets: {0}".format(e))

def upload_file(file, bucket_name):
    print("Uploading {0} to bucket  {1}".format(file, bucket_name))
    try:
        key = os.path.basename(file)
        cos_client.upload_file(file, bucket_name, key)
        print("File {0} uploaded to {1}".format(file, bucket_name))
        return key
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to upload: {0}".format(e))

def download_file(bucket_name, key, file):
    print("Downloading {0} from bucket  {1}".format(key, bucket_name))
    try:
        cos_client.download_file(Bucket=bucket_name, Key=key,  Filename=file)
        print("File {0} downloaded from {1}".format(file, bucket_name))
    except ClientError as be:
        print("CLIENT ERROR: {0}\n".format(be))
    except Exception as e:
        print("Unable to download: {0}".format(e))