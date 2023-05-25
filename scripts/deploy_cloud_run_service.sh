#!/usr/bin/env bash

set -e
set -o pipefail
set -u

echo "############# Deploying the Cloud Run service $SERVICE_NAME"

gcloud run deploy "$SERVICE_NAME" \
  --image "$LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$SERVICE_NAME:$IMAGE_TAG" \
  --region="$LOCATION" \
  --set-env-vars PROJECT_ID="$PROJECT_ID" \
  --set-env-vars OUTPUT_DATASET="$OUTPUT_DATASET" \
  --set-env-vars OUTPUT_TABLE="$OUTPUT_TABLE" \
  --set-env-vars INPUT_BUCKET="$INPUT_BUCKET" \
  --set-env-vars INPUT_OBJECT="$INPUT_OBJECT"
