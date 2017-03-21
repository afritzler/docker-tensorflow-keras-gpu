FROM tensorflow/tensorflow:latest-gpu

MAINTAINER Andreas Fritzler <andreas.fritzler@gmail.com>

RUN pip --no-cache-dir install keras

RUN apt-get update && apt-get install -y git nvidia-375 cuda-8-0 \
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/fchollet/keras.git

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
