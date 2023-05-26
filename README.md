# teams-league-cloudrun-service-fastapi

Project showing a complete use case with a Cloud Run Service written with a Python module and multiple files. The deployment of service is done with FastApi and Uvicorn.

The link to the article :

https://medium.com/@mazlum.tosun/cloud-run-service-with-a-python-module-fastapi-and-uvicorn-24c94090a008

## Build the container for Cloud Run Service with Cloud Build

Update `GCloud CLI` :

```bash
gcloud components update
```

Execute the following commands :

```bash
export PROJECT_ID=$(gcloud config get-value project)
export SERVICE_NAME=load-and-transform-team-stats-to-bq-service

gcloud builds submit --tag europe-west1-docker.pkg.dev/${PROJECT_ID}/internal-images/${SERVICE_NAME}:latest ./team_league/service
```

## Deploy the container image to Cloud Run

```bash
gcloud run deploy ${SERVICE_NAME} \
  --image europe-west1-docker.pkg.dev/${PROJECT_ID}/internal-images/${SERVICE_NAME}:latest \
  --region=${LOCATION}
```

Execution from a local machine with a Cloud Build yaml file :

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-service.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_SERVICE_NAME="$SERVICE_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT" \
    --verbosity="debug" .
```

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