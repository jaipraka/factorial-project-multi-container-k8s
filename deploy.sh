### Build images using production Dockerfile
# Specify muliple tags

GIT_SHA=$(git rev-parse --short HEAD || echo "GitNotFound")
# Build react-client image
docker build -t pakuthota/factorial-project-react-client-k8s:latest -t pakuthota/factorial-project-react-client-k8s:$GIT_SHA -f ./react-client/Dockerfile ./react-client

# Build express-server image
docker build -t pakuthota/factorial-project-express-server-k8s:latest -t pakuthota/factorial-project-express-server-k8s:$GIT_SHA -f ./express-server/Dockerfile ./express-server

# Build worker image
docker build -t pakuthota/factorial-project-worker-k8s:latest -t pakuthota/factorial-project-worker-k8s:$GIT_SHA -f ./worker/Dockerfile ./worker

### Push images

# Push latest tag images to docker hub
docker push pakuthota/factorial-project-react-client-k8s:latest
docker push pakuthota/factorial-project-express-server-k8s:latest
docker push pakuthota/factorial-project-worker-k8s:latest

# Push sha tag images to docker hub
docker push pakuthota/factorial-project-react-client-k8s:$GIT_SHA
docker push pakuthota/factorial-project-express-server-k8s:$GIT_SHA
docker push pakuthota/factorial-project-worker-k8s:$GIT_SHA

### Deploy

# Apply k8s config
kubectl apply -f k8s

# Update react-client image
kubectl set image deployments/react-client-deployment react-client=pakuthota/factorial-project-react-client-k8s:$GIT_SHA

# Update express-server image
kubectl set image deployments/express-server-deployment express-server=pakuthota/factorial-project-express-server-k8s:$GIT_SHA

# Update worker image
kubectl set image deployments/worker-deployment worker=pakuthota/factorial-project-worker-k8s:$GIT_SHA
