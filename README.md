# docker-tensorflow-keras-gpu
Base image with Tensorflow and Keras with GPU support. The purpose of this project is to run a single Pod on Kubernetes on a GPU backed node.

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
kubectl exec -it tensorflow-keras-gpu -- /bin/bash
```

# References
[1] https://www.tensorflow.org/

[2] https://keras.io/

[3] https://kubernetes.io/docs/user-guide/kubectl/kubectl_label/

[4] https://kubernetes.io/docs/user-guide/kubectl/kubectl_create/

[5] https://kubernetes.io/docs/user-guide/kubectl/kubectl_exec/
