#!/bin/bash
#    Copyright 2026 Proximity Robotics & Automation GmbH

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

uid=$(eval "id -u")
gid=$(eval "id -g")
# ANSI escape codes
RED_BOLD="\033[1;31m"
YELLOW_BOLD="\033[1;33m"
GREEN_BOLD="\033[1;32m"
RESET="\033[0m"

PACKAGE_NAME="px_seyond_docker"
ROS_DISTRO="humble"

# Set Package root
if [[ "$(pwd)" == *"/$PACKAGE_NAME/"* ]]; then
    # Case A: Inside a subdirectory
    echo -e "${YELLOW_BOLD}Inside subdirectory. Navigating to root...${RESET}"
    # Strip everything after the package name to find the root
    PACKAGE_ROOT="${(pwd)%%/$PACKAGE_NAME/*}/$PACKAGE_NAME"
    cd "$PACKAGE_ROOT" || exit 1
elif [[ "$(pwd)" == *"/$PACKAGE_NAME" ]]; then
    # Case B: Already at the root
    echo -e "${GREEN_BOLD}Already at package root.${RESET}"
    PACKAGE_ROOT="$(pwd)"
else
    # Case C: Not in the package at all
    echo -e "${RED_BOLD}Error: You are not inside the directory '$PACKAGE_NAME'.${RESET}"
    echo "Current path: $(pwd)"
    exit 1
fi

# Check if DISPLAY is set
if [ "$DISPLAY" ]; then
    xhost + local:root
fi

# Check and create necessary folders
for FOLDER in ros2_ws/src env data; do
    HOST_PATH="$PACKAGE_ROOT/$FOLDER"
    if [ ! -d "$HOST_PATH" ]; then
        echo -e "${YELLOW_BOLD}Warning: $HOST_PATH does not exist. Creating it...${RESET}"
        mkdir -p "$HOST_PATH"
    fi
done

docker run \
    --name $PACKAGE_NAME \
    --gpus all \
    -it \
    --privileged \
    --net host \
    --ipc host \
    -e QT_X11_NO_MITSHM=1 \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev:/dev \
    -v ~/.Xauthority:/home/robot/.Xauthority \
    -v $PACKAGE_ROOT/ros2_ws:/home/robot/ros2_ws \
    -v $PACKAGE_ROOT/env:/home/robot/env \
    -v $PACKAGE_ROOT/data:/home/robot/data \
    --rm \
    $PACKAGE_NAME/ros:$ROS_DISTRO
