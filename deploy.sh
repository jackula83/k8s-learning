# build all our images, tag each one, push each to docker hub
docker build -t jackula83/multi-client:latest -t jackula83/multi-client:$SHA ./client
docker build -t jackula83/multi-server:latest -t jackula83/multi-server:$SHA ./server
docker build -t jackula83/multi-worker -t jackula83/multi-worker:$SHA ./worker

docker push jackula83/multi-client:latest
docker push jackula83/multi-server:latest
docker push jackula83/multi-worker:latest
docker push jackula83/multi-client:$SHA
docker push jackula83/multi-server:$SHA
docker push jackula83/multi-worker:$SHA

# apply all configs in the k8s folder
kubectl apply -f k8s

# imperatively set latest images on each deployment
kubectl set image deployment/server-deployment server=jackula83/multi-server:$SHA
kubectl set image deployment/client-deployment client=jackula83/multi-client:$SHA
kubectl set image deployment/worker-deployment worker=jackula83/multi-worker:$SHA