# teams-league-airflow-elt

This project shows a real world use case with ELT pipeline using Cloud Storage, BigQuery, Airflow and Cloud Composer

The link to the video : 

https://youtu.be/XT-xdEtN0dA

The link to the article :

https://medium.com/@mazlum.tosun/elt-batch-pipeline-with-cloud-storage-bigquery-orchestrated-by-airflow-composer-8bbfc80bf171

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

The same with the yaml file :
`
```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-service.yaml \
    --substitutions _REPO_NAME="internal-images",_SERVICE_NAME="$SERVICE_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT" \
    --verbosity="debug" .
```