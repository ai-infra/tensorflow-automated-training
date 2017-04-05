# TensorFlow training using Docker

Refer to the section - ‘How to Fine-Tune a Pre-Trained Model on a New Task” 
in the following link: https://github.com/tensorflow/models/tree/master/inception
for details on the example used here

## Build the docker image

Clone this repo. Place the bazel and tensorflow binaries in this folder before starting the docker image build. 

Refer to the following github project to build bazel and tensorflow for PowerPC LE 
https://github.com/ai-infra/tensorflow-automated-build.git

Run the following command to build the docker image
```bash
docker build -t ppc64le/tf-train-flowers -f Dockerfile.ppc64le .
```

## Run the docker image to start training

### Assumptions

- CUDA 8.0 toolkit is installed
 Refer to the following link for CUDA download - https://developer.nvidia.com/cuda-downloads?cm_mc_uid=&cm_mc_sid_50200000=#linux-power8
 On Ubuntu 16.04, Cuda 8.0 packages  will be available under /usr/local/cuda-8.0/ and /usr/lib/powerpc64le-linux-gnu/ after installation
- cuDNN downloaded and extracted in /usr/local/cuda-8.0
 Refer to the following link for cuDNN download - https://developer.nvidia.com/cudnn

- nvidia-375 driver is installed on the  host on /usr/lib/nvidia-375/
 Refer to the following link for Nvidia driver download - http://www.nvidia.com/download/driverResults.aspx/115753/en-us

If the installation paths or nvidia driver versions are different then modify the docker run command accordingly

### Start training

```bash
docker run -it --privileged -v /usr/local/cuda-8.0/:/usr/local/cuda-8.0/ -v /usr/lib/powerpc64le-linux-gnu/:/usr/lib/powerpc64le-linux-gnu/ -v /usr/lib/nvidia-375/:/usr/lib/nvidia-375/ -v /root/runs:/flowers-train ppc64le/tf-train-flowers /bin/bash -c "./run-trainer.sh 10000 && rsync -ah flowers_train/ flowers-train/"
```

### Deploying in a Kubernetes based GPU cluster

Look at the sample YAML file - tf-inception-trainer-flowers.yaml 
