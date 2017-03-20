FROM tensorflow/tensorflow:1.0.1-devel-gpu

MAINTAINER Andreas Fritzler <andreas.fritzler@gmail.com>

RUN pip --no-cache-dir install keras

RUN ["/bin/bash"]
