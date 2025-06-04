# teams-league-cloudrun-service-fastapi

Project showing a complete use case with a Cloud Run Service written with a Python module and multiple files. The deployment of service is done with FastApi and Uvicorn.

The link to the article :

https://medium.com/@mazlum.tosun/cloud-run-service-with-a-python-module-fastapi-and-uvicorn-24c94090a008

The video in English :

https://youtu.be/rNVDnqpmpIU

The video in French :

https://youtu.be/MJ8WfgnE-wo

## Local execution with Docker and gcloud CLI

Update `GCloud CLI` :

```bash
gcloud components update
```

### Build the Docker image locally and publish it to Artifact Registry

Set env vars:

```bash
export PROJECT_ID={{project_id}}
export LOCATION=europe-west1
export SERVICE_NAME=teams-league-service
export REPO_NAME=internal-images
export IMAGE_TAG="latest"
```

Authenticate in GCP with ADC:

```bash
gcloud auth application-default login
```

Configure Docker to use your gcloud credentials
Use this command to configure Docker authentication for the registry:

```bash
gcloud auth configure-docker $LOCATION-docker.pkg.dev
```

Execute the following commands :

```bash
docker build -f team_league/service/Dockerfile -t $SERVICE_NAME .
docker tag $SERVICE_NAME $LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$SERVICE_NAME:$IMAGE_TAG
docker push $LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$SERVICE_NAME:$IMAGE_TAG
```

### Deploy the Cloud Run service locally, based in the image published previously

```bash
gcloud run deploy ${SERVICE_NAME} \
  --image europe-west1-docker.pkg.dev/${PROJECT_ID}/internal-images/${SERVICE_NAME}:latest \
  --region=${LOCATION}
```

## Execution from a CI CD pipeline and Cloud Build

### Execution from a CI CD pipeline and Cloud Build from local machine

Execution from a local machine with a Cloud Build yaml file :

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-service.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_SERVICE_NAME="$SERVICE_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT" \
    --verbosity="debug" .
```

### Execution from a CI CD pipeline and a manual trigger in the Cloud Build page (GCP console)

Execution with a Cloud Build manual trigger :

```bash
gcloud beta builds triggers create manual \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --name="deploy-cloud-run-service-team-league" \
    --repo="https://github.com/tosun-si/teams-league-cloudrun-service-fastapi" \
    --repo-type="GITHUB" \
    --branch="main" \
    --build-config="deploy-cloud-run-service.yaml" \
    --substitutions _REPO_NAME="$REPO_NAME",_SERVICE_NAME="$SERVICE_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT" \
    --verbosity="debug"
```