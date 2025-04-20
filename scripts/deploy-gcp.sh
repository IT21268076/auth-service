#!/bin/bash

# Script to deploy auth-service to Google Kubernetes Engine (GKE)

set -e

# Set variables
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME="auth-service-cluster"
ZONE="us-central1-a"
REGION="us-central1"

echo "Deploying to GCP project: $PROJECT_ID"

# Build and push Docker image to GCR
echo "Building and pushing Docker image..."
docker build -t gcr.io/$PROJECT_ID/auth-service:latest .
docker push gcr.io/$PROJECT_ID/auth-service:latest

# Create GKE cluster if it doesn't exist
if ! gcloud container clusters describe $CLUSTER_NAME --zone $ZONE &>/dev/null; then
  echo "Creating GKE cluster..."
  gcloud container clusters create $CLUSTER_NAME \
    --zone $ZONE \
    --num-nodes=1 \
    --machine-type=e2-medium
fi

# Configure kubectl to use the cluster
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE

# Update Kubernetes configuration with project ID
sed -i.bak "s|PROJECT_ID|$PROJECT_ID|g" kubernetes/deployment.yaml

# Apply Kubernetes configurations
echo "Applying Kubernetes configurations..."
kubectl apply -f kubernetes/mysql.yaml
echo "Waiting for MySQL to be ready..."
sleep 30  # Give MySQL some time to initialize

kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

# Wait for services to be assigned external IPs
echo "Waiting for service to get external IP..."
sleep 30

# Get the external IP
EXTERNAL_IP=$(kubectl get service auth-service -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "Deployment complete!"
echo "Auth Service is available at: http://$EXTERNAL_IP"