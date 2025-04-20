#!/bin/bash

# Script to clean up GCP resources

set -e

# Set variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME="auth-service-cluster"
ZONE="us-central1-a"

echo "Cleaning up GCP resources in project: $PROJECT_ID"

# Delete Kubernetes resources
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE
kubectl delete service auth-service
kubectl delete deployment auth-service
kubectl delete service mysql
kubectl delete deployment mysql
kubectl delete secret mysql-credentials
kubectl delete pvc mysql-pvc

# Delete GKE cluster
echo "Deleting GKE cluster..."
gcloud container clusters delete $CLUSTER_NAME --zone $ZONE --quiet

# Delete container images
echo "Deleting container images..."
gcloud container images delete gcr.io/$PROJECT_ID/auth-service:latest --quiet

echo "Cleanup complete!"