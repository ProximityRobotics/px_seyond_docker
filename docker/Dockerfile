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


##############################################################################
##                                 Base Image                               ##
##############################################################################
ARG ROS_DISTRO=humble
FROM ros:$ROS_DISTRO-ros-base
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update packages only if necessary, ~250MB
# RUN apt update && apt -y dist-upgrade

##############################################################################
##                                 Global Dependecies                       ##
##############################################################################
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-pip \
    wget \
    python3-colcon-common-extensions \
    libpcl-dev \
    libpcl-conversions-dev \
    libpcap-dev \
    ros-$ROS_DISTRO-pcl* \
    ros-$ROS_DISTRO-rviz2 \
    ros-$ROS_DISTRO-rqt* \
    ros-$ROS_DISTRO-ros2bag* \
    ros-$ROS_DISTRO-rosbag2-storage-mcap \
    ros-$ROS_DISTRO-foxglove-msgs \
    ros-$ROS_DISTRO-foxglove-bridge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

##############################################################################
##                                 Create User                              ##
##############################################################################
ARG USER=robot
ARG PASSWORD=robot
ARG UID=1000
ARG GID=1000
ARG DOMAIN_ID=0
ENV UID=$UID
ENV GID=$GID
ENV USER=$USER
ENV ROS_DOMAIN_ID=${DOMAIN_ID}
RUN groupadd -g "$GID" "$USER"  && \
    useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
    echo "$USER:$PASSWORD" | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

COPY env/fast_dds_1.xml /home/$USER
RUN chown $USER:$USER /home/$USER/fast_dds_1.xml
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/home/$USER/fast_dds_1.xml
RUN echo "export ROS_DOMAIN_ID=${DOMAIN_ID}" >> /etc/bash.bashrc

USER $USER 
RUN mkdir -p /home/$USER/ros2_ws/src

##############################################################################
##                                 User Dependecies                         ##
##############################################################################
WORKDIR /home/$USER/ros2_ws/src

# Install seyond_ros_driver
RUN git clone https://github.com/Seyond-Inc/seyond_ros_driver.git
WORKDIR /home/$USER/ros2_ws/src/seyond_ros_driver
RUN git submodule update --init
RUN ./build.bash

##############################################################################
##                                 Build ROS and run                        ##
##############################################################################
WORKDIR /home/$USER/ros2_ws
RUN sudo apt-get update && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build --symlink-install
RUN echo "source /home/$USER/ros2_ws/install/setup.bash" >> /home/$USER/.bashrc

RUN sudo sed --in-place --expression \
    '$isource "/home/$USER/ros2_ws/install/setup.bash"' \
    /ros_entrypoint.sh

CMD ["ros2", "launch", "seyond", "start.py"]
