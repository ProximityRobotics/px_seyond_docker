#!/bin/sh
uid=$(eval "id -u")
gid=$(eval "id -g")

docker build \
    --build-arg UID="$uid" \
    --build-arg GID="$gid" \
    --network host \
    -t seyond_driver/ros:humble .
