import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    # Fine to fail fast with KeyErrors if any of the required env vars are missing
    region = os.environ["ECS_REGION"]
    cluster_name = os.environ["ECS_CLUSTER_NAME"]
    service_name = os.environ["ECS_SERVICE_NAME"]

    client = boto3.client("ecs", region_name=region)
    # See https://docs.aws.amazon.com/boto3/latest/reference/services/ecs/client/update_service.html
    client.update_service(
        cluster=cluster_name,
        service=service_name,
        forceNewDeployment=True,
    )
    logger.info(
        "Forced ECS deployment of service %s in cluster %s", service_name, cluster_name
    )
