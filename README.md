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

# References
[1] https://www.tensorflow.org/

[2] https://keras.io/

[3] https://kubernetes.io/docs/user-guide/kubectl/kubectl_label/

[4] https://kubernetes.io/docs/user-guide/kubectl/kubectl_create/

[5] https://kubernetes.io/docs/user-guide/kubectl/kubectl_attach/
