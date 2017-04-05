#!/bin/bash

if [ $1 ];  then
  ITERATIONS=$1
else
  echo $0": usage: ./run-traner.sh [iterations]"
  exit 1
fi

curl -O http://download.tensorflow.org/models/image/imagenet/inception-v3-2016-03-01.tar.gz && \
tar xzf inception-v3-2016-03-01.tar.gz && \
ls inception-v3

mkdir /flowers-data

cd /models/inception && \
export LD_LIBRARY_PATH=/usr/lib/powerpc64le-linux-gnu/ && \
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64/ && \
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia-375/ && \
bazel build inception/download_and_preprocess_flowers && \
bazel-bin/inception/download_and_preprocess_flowers /flowers-data && \

# Build the model. Note that we need to make sure the TensorFlow is ready to
# use before this as this command will not build TensorFlow.
bazel build inception/flowers_train

# Path to the downloaded Inception-v3 model.
MODEL_PATH="/inception-v3/model.ckpt-157585"

# Directory where the flowers data resides.
FLOWERS_DATA_DIR=/flowers-data/

# Directory where to save the checkpoint and events files.
TRAIN_DIR=/flowers_train/

# Run the fine-tuning on the flowers data set starting from the pre-trained
# Imagenet-v3 model.
bazel-bin/inception/flowers_train \
  --train_dir="${TRAIN_DIR}" \
  --data_dir="${FLOWERS_DATA_DIR}" \
  --pretrained_model_checkpoint_path="${MODEL_PATH}" \
  --fine_tune=True \
  --initial_learning_rate=0.001 \
  --max_steps="${ITERATIONS}" \
  --input_queue_memory_factor=1
