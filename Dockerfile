FROM tensorflow/tensorflow:1.0.1-devel-gpu

MAINTAINER Andreas Fritzler <andreas.fritzler@gmail.com>

RUN pip --no-cache-dir install keras

RUN git clone https://github.com/fchollet/keras.git

RUN ["sleep 3600"]
