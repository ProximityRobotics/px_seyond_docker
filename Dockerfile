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

RUN pip install     \
    pillow          \
    scikit-learn    \
    pandas          \
    numpy==1.24.4   \
    filterpy        

##############################################################################
##                                 Create User                              ##
##############################################################################
ARG USER=docker
ARG PASSWORD=docker
ARG UID=1000
ARG GID=1000
ENV UID=$UID
ENV GID=$GID
ENV USER=$USER
RUN groupadd -g "$GID" "$USER"  && \
    useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
    echo "$USER:$PASSWORD" | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

COPY config/dds_profile.xml /home/$USER
RUN chown $USER:$USER /home/$USER/dds_profile.xml
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/home/$USER/dds_profile.xml

USER $USER 
RUN mkdir -p /home/$USER/ros2_ws/src

##############################################################################
##                                 User Dependecies                         ##
##############################################################################
WORKDIR /home/$USER
COPY seyond_driver/seyond-ros2-humble-3.102.0-rv3.5.2pre-x86-public.deb /home/$USER
RUN sudo dpkg -i seyond-ros2-humble-3.102.0-rv3.5.2pre-x86-public.deb

COPY src /home/$USER/ros2_ws/src

####### Innovusion SDK is out of date and will not be installed #######
# WORKDIR /home/$USER/ros2_ws/src
# COPY seyond_driver/inno_lidar_ros inno_lidar_ros/.

# ARG CLIENT_SDK_PATH=/home/$USER/ros2_ws/src/inno_lidar_ros/src/inno_sdk
# ENV CLIENT_SDK_PATH=$CLIENT_SDK_PATH
# WORKDIR ${CLIENT_SDK_PATH}/build
# RUN shared=1 sudo ./build_unix.sh && \
#     echo "build status: $?"
##############################################

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

CMD ["bash"]
