# docker-tensorflow-keras-gpu
Base image with Tensorflow and Keras with GPU support

# Run it on Kubernetes

We need to label the gpu instance first (if not already done)
```
kubectl label node <NODE_NAME> gpu="true"
```

Now run a simple deployment
```
kubectl create -f example-pod.yaml
```

Attach to the running container
```
kubectl attach ...
```
