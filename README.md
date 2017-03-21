# docker-tensorflow-keras-gpu
Base image with Tensorflow and Keras with GPU support. The purpose of this project is to run a single Pod on Kubernetes on a GPU backed node.

# Run it on Kubernetes

First, we need to label the gpu instance (if not already done)
```
kubectl label node <NODE_NAME> gpu="true"
```

__Tricky part ahead:___

In order to use the GPU inside your docker container, you need to pass the location of the NVidia driver on the host into your container. Since the GPU kernel driver on the host has to match the nvidia-driver inside the contianer, we want to decouple that. Adjust the `path` in the `example-pod.yaml` file in case your nvidia-driver location is different. 

```
volumes:
  - name: nvidia-driver
    hostPath:
      path: /var/lib/nvidia-docker/volumes/nvidia_driver/latest
```

Now run a simple deployment
```
kubectl create -f example-pod.yaml
```

Attach to the running container
```
kubectl exec -it tensorflow-keras-gpu -- /bin/bash
```

# Lets do some training

Inside the docker container I placed the Keras examples from github. To run a simple training example on the IMDB dataset
```
cd /keras/example
python imdb_cnn.py
```
If your configuration and driver mapping was done correctly, you should see something like that before the training starts.
```
Creating TensorFlow device (/gpu:0) -> (device: 0, name: GeForce GTX TITAN X, pci bus id: 0000:09:00.0)
```

# References
* https://www.tensorflow.org/
* https://keras.io/
* https://kubernetes.io/docs/user-guide/kubectl/kubectl_label/
* https://kubernetes.io/docs/user-guide/kubectl/kubectl_create/
* https://kubernetes.io/docs/user-guide/kubectl/kubectl_exec/
