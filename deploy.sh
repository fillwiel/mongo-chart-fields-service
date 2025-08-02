#!/bin/bash

set -e

echo "=== 🚀 Deploying mongo-chart-fields-service ==="

# Use current directory
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="mongo-chart-fields:latest"
DEPLOYMENT_FILE="$PROJECT_DIR/k8s/mongo-chart-fields-deployment.yaml"
SERVICE_FILE="$PROJECT_DIR/k8s/mongo-chart-fields-service.yaml"
SECRET_NAME="mongo-chart-fields-secrets"
ENV_FILE="$PROJECT_DIR/.env"

cd "$PROJECT_DIR"

# Step 1: Pull latest changes (optional — skip if CI/CD handles this)
if [ -d .git ]; then
  echo "📥 Pulling latest changes..."
  git pull origin main
fi

# Step 2: Check for .env file
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Missing .env file!"
  exit 1
fi

# Step 3: Build Docker image
echo "🐳 Building Docker image..."
docker build --no-cache -t $IMAGE_NAME .

# Step 4: Import to k3s
echo "📦 Importing image into k3s..."
docker save $IMAGE_NAME | sudo k3s ctr images import -

# Step 5: Create/update secret
echo "🔐 Creating/updating Kubernetes secret..."
kubectl delete secret $SECRET_NAME --ignore-not-found
kubectl create secret generic $SECRET_NAME --from-env-file=$ENV_FILE

# Step 6: Apply manifests
echo "⚙️ Applying Kubernetes manifests..."
kubectl apply -f "$DEPLOYMENT_FILE"
kubectl apply -f "$SERVICE_FILE"

echo "✅ Deployment complete!"
