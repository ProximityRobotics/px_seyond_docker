# pxSeyondDocker

This docker pulls and builds the latest [seyond_ros_driver](https://github.com/Seyond-Inc/seyond_ros_driver) from GitHub and runs it in a ROS 2 Jazzy environment.

The LiDAR needs to be connected to your PC via Ethernet and you need to set your IP settings as following:

Address: ```172.168.1.42```

Netmask: ```255.255.0.0```

## How to use

clone the seyond_driver repo

```bash
git clone <repo>
```

build the docker image

```bash
./docker/build_image.sh
```

Run the container

```bash
./docker/run_container.sh
```

### Run the driver

The driver should start automatically using the ```start.py``` launch file.

## Configurations

For more information on configuration of the LIDAR please look at the official [seyond_ros_driver](https://github.com/Seyond-Inc/seyond_ros_driver) repository.

## Acknowledgment

[Proximity Robotics & Automation GmbH](mailto:info@proximityrobotics.com)

## License

Copyright 2026 Proximity Robotics & Automation GmbH

> Licensed under the Apache License, Version 2.0 (the "License");
> you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
>
> [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
>
> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> See the License for the specific language governing permissions and
> limitations under the License.
