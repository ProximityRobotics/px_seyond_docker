#!/bin/sh
echo "Run Container"
xhost + local:root

docker run --name seyond_driver \
    --privileged \
    -it \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    --gpus all \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/.Xauthority:/home/docker/.Xauthority \
    -v /dev:/dev \
    -v $PWD/data:/home/docker/data \
    -v $PWD/src:/home/docker/ros2_ws/src \
    --net host \
    --rm \
    --ipc host \
    seyond_driver/ros:humble
