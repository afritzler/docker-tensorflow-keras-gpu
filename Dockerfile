FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

MAINTAINER Andreas Fritzler <andreas.fritzler@gmail.com>

ARG THEANO_VERSION=rel-0.8.2
ARG TENSORFLOW_VERSION=1.0.1
ARG TENSORFLOW_ARCH=gpu
ARG KERAS_VERSION=1.0.3
ARG BAZEL_VERSION=0.4.3

# Install some dependencies
RUN apt-get update && apt-get install -y \
		bc \
		build-essential \
		cmake \
		curl \
		g++ \
		gfortran \
		git \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libopenjpeg2 \
		libpng12-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
		nano \
		pkg-config \
		python-dev \
		python3-dev \
		software-properties-common \
		unzip \
		vim \
		wget \
		zlib1g-dev \
		htop \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \
# Link BLAS library to use OpenBLAS using the alternatives mechanism (https://www.scipy.org/scipylib/building/linux.html#debian-ubuntu)
	update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3

# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
	python get-pip.py && \
	rm get-pip.py

# Add SNI support to Python
RUN pip --no-cache-dir install \
		pyopenssl \
		ndg-httpsclient \
		pyasn1

RUN apt-get update && apt-get install -y \
		python-numpy \
		python-scipy \
		python-nose \
		python-h5py \
		python-skimage \
		python-matplotlib \
		python-pandas \
		python-sklearn \
		python-sympy \
		python-setuptools \
		swig \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk openjdk-8-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo "startup --batch" >>/root/.bazelrc
RUN echo "build --spawn_strategy=standalone --genrule_strategy=standalone" \
    >>/root/.bazelrc
ENV BAZELRC /root/.bazelrc

WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE.txt && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Download and build TensorFlow.
RUN git clone --recursive https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git checkout v$TENSORFLOW_VERSION
WORKDIR /tensorflow

ENV TF_NEED_CUDA=1 \
     GCC_HOST_COMPILER_PATH=/usr/bin/gcc \
     TF_CUDA_VERSION=8.0 \
     CUDA_TOOLKIT_PATH=/usr/local/cuda \
     TF_CUDNN_VERSION=5 \
     CUDNN_INSTALL_PATH=/usr/local/cuda \
     TF_CUDA_COMPUTE_CAPABILITIES=3.5,3.7,5.2,6.0 \
     CC_OPT_FLAGS="--copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda" \
     PYTHON_BIN_PATH="/usr/bin/python3" \
     USE_DEFAULT_PYTHON_LIB_PATH=1 \
     TF_NEED_JEMALLOC=1 \
     TF_NEED_GCP=0 \
     TF_NEED_HDFS=0 \
     TF_ENABLE_XLA=0 \
     TF_NEED_OPENCL=0

RUN ./configure && \
    bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda tensorflow/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip && \
    pip install --upgrade /tmp/pip/tensorflow-*.whl && \
    rm -rf /root/.cache
    
RUN pip --no-cache-dir install git+https://github.com/fchollet/keras.git@${KERAS_VERSION}

RUN git clone https://github.com/fchollet/keras.git

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
